# Adapting auto-spicy-github to Other Platforms

auto-spicy-github was designed for Claude Code, Gemini CLI, and Copilot CLI — platforms where `Skill()` dispatch resolves automatically. On everything else you can still run this pipeline, but you are handling the orchestration yourself.

![Platform support matrix](docs/assets/svg/platform-support.svg)
*Three native platforms, two manual, one honest account of what you lose.*

---

## Raw API / any capable LLM

Paste all three skill files into your system prompt before the conversation starts:

1. `skills/github-docs/SKILL.md`
2. `skills/art-direction/SKILL.md`
3. `skills/visual-output-standards/SKILL.md`

Add this header above them:

```
# Loaded skills: github-docs, art-direction, visual-output-standards
# When Skill("name") appears in any instruction, execute that skill's content inline.
```

Then send: `update the github documentation`

The pipeline runs end-to-end. Every `Skill()` call is resolved by the instructions already in context.

**Which skills to include:**

| Use case | Skills to inline |
|----------|-----------------|
| Full pipeline | github-docs + art-direction + visual-output-standards |
| Visual identity only | art-direction |
| SVG/chart generation only | visual-output-standards |

---

## Cursor / Windsurf / other IDE agents

1. Create `.cursorrules` (or `.windsurfrules`, or your IDE's equivalent) at your project root
2. Paste the three skill files into it, preceded by the header above
3. Open the repo and trigger the pipeline

**What you lose:** `Skill()` calls are Claude Code tool invocations that IDE agents do not resolve natively. The inlining approach above substitutes for that. `gh issue create` calls in Step 3 require the GitHub CLI installed and authenticated in the IDE's terminal. `~/.claude/skills/` is not read by IDE agents — inlining is the only load path.

---

## ChatGPT

Paste `skills/github-docs/SKILL.md` into Custom Instructions. Run the pipeline step by step — paste the numbered step you want to execute and ask the model to run it.

**Steps that need manual intervention:**

- **Step 2:** If `VISUAL-IDENTITY.md` is missing, paste `skills/art-direction/SKILL.md` into the chat and ask the model to run the discovery conversation.
- **Step 5:** Before requesting SVGs, paste `skills/visual-output-standards/SKILL.md`.
- **Step 6:** Requires web browsing. ChatGPT with browsing handles this. Models without web access cannot fetch images — provide URLs manually or skip.
- **Step 8:** ChatGPT cannot run `git`. Copy the output into your repo and commit yourself.

---

## What you lose on non-Claude platforms

| Capability | Claude Code | Other platforms |
|-----------|-------------|-----------------|
| `Skill()` auto-dispatch | Automatic | Manual — paste content |
| Persistent skill loading | `~/.claude/skills/` | System prompt only |
| art-direction auto-trigger | On missing `VISUAL-IDENTITY.md` | You recognize and paste |
| `git` / `gh` operations | Native shell access | Run yourself |
| Web search + image fetch | Built-in tools | Platform-dependent |

The pipeline logic is portable to any capable LLM. The automation layer is Claude Code.
