# Adapting auto-spicy-github to Other Platforms

auto-spicy-github was built for Claude Code, Gemini CLI, and Copilot CLI — environments where the `Skill()` dispatch mechanism works automatically. On other platforms you can still use these skills, but the orchestration becomes manual.

---

## Raw prompt / API usage

Paste the full contents of `skills/github-docs/SKILL.md` as your system prompt. Then send a user message: `update the github documentation`.

The model will walk through Steps 1–9. Two steps require special handling:

- **Step 2 (art-direction dispatch):** The skill calls `Skill("art-direction")`. Your model cannot resolve that. Before your session, also paste the contents of `skills/art-direction/SKILL.md` into the system prompt. Tell the model: "If art-direction is needed, run the discovery conversation inline — the skill content is already loaded."
- **Step 5 (visual-output-standards dispatch):** Same situation. Paste `skills/visual-output-standards/SKILL.md` into the system prompt as well.

When all three skill files are inlined into the system prompt, the pipeline runs end-to-end with no tool-dispatch gaps. The tradeoff is a larger context window consumed upfront.

**Which skills to include for which use cases:**

| Use case | Skills to inline |
|---|---|
| Full documentation pipeline | github-docs + art-direction + visual-output-standards |
| Visual identity only | art-direction |
| SVG/chart generation only | visual-output-standards |

---

## Cursor / Windsurf / other IDE agents

Copy skill content into `.cursorrules`, `.windsurfrules`, or your IDE's equivalent system prompt config.

1. Create `.cursorrules` (or equivalent) at your project root.
2. Paste the full contents of `skills/github-docs/SKILL.md` into it.
3. Paste `skills/art-direction/SKILL.md` and `skills/visual-output-standards/SKILL.md` below it in the same file.
4. Add a header comment: `# These skills are pre-loaded. When Skill() calls appear, execute inline.`

**Limitations:**

- `Skill()` calls in the skill files are Claude Code tool invocations. In Cursor/Windsurf, they become no-ops unless you manually instruct the model to treat them as inline sections. The inlining approach above is the workaround.
- No automatic skill loading from `~/.claude/skills/` — IDE agents do not read that directory.
- `gh issue create` calls in Step 3 require the GitHub CLI installed and authenticated in the IDE's terminal environment.

---

## ChatGPT / other LLMs

Paste `skills/github-docs/SKILL.md` as the system prompt (Custom Instructions or equivalent). Then run the pipeline manually, one step at a time, prompting the model to execute each numbered step.

**Steps that need attention:**

- **Step 2:** If `docs/assets/VISUAL-IDENTITY.md` does not exist, paste `skills/art-direction/SKILL.md` into the chat and ask the model to run the discovery conversation.
- **Step 5:** Before generating SVGs, paste `skills/visual-output-standards/SKILL.md` into the chat.
- **Step 6 (artwork fetch):** This step requires WebSearch and WebFetch. ChatGPT with browsing enabled can handle this. Models without web access cannot fetch images — skip Step 6 or supply image URLs manually.
- **Step 8 (commit):** ChatGPT cannot run `git` commands. Copy the model's file output into your repo manually, then commit yourself.

---

## What you lose on non-Claude platforms

Be clear-eyed about the tradeoffs:

- **`Skill()` dispatch is manual.** Every `Skill("art-direction")` and `Skill("visual-output-standards")` call is an instruction to load a file Claude Code resolves automatically. On other platforms you handle that yourself — either by inlining content upfront or by pasting it mid-session.
- **No persistent skill loading.** Claude Code reads from `~/.claude/skills/` at invocation time. Other platforms have no equivalent. Every session starts from whatever you put in the system prompt.
- **No automatic art-direction dispatch.** When `docs/assets/VISUAL-IDENTITY.md` is missing, Claude Code automatically loads the art-direction skill. Other platforms require you to recognize that situation and paste the skill content manually.
- **Git operations require a local shell.** Steps 8 (commit) and parts of Step 3 (filing GitHub Issues) require CLI access. Web-based LLMs cannot do this — you run those commands yourself.

The pipeline logic is sound on any capable LLM. The automation layer is Claude Code-specific.
