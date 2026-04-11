# Getting Started

## Prerequisites

You need [Claude Code](https://claude.ai/code) installed and authenticated.

```bash
# Verify Claude Code is installed
claude --version
```

---

## Install auto-spicy-github

```bash
git clone https://github.com/YOUR_USERNAME/auto-spicy-github.git
cd auto-spicy-github
./install.sh
```

The installer copies the three skills (`github-docs`, `art-direction`, `visual-output-standards`) into `~/.claude/skills/`. Claude Code reads that directory at startup — the skills are available immediately in any new session.

---

## Run it on your repo

Navigate to the repo you want to document:

```bash
cd ~/projects/your-repo
claude
```

Then say:

```
update the github documentation
```

That phrase triggers the `github-docs` skill. Nothing else needed.

---

## What happens next

**First run on a repo with no visual identity:**

1. Claude checks for `docs/assets/VISUAL-IDENTITY.md` — it does not exist.
2. The `art-direction` skill loads automatically and runs a short discovery conversation (4 questions about personality, aesthetic, existing brand materials, and visual references — all optional).
3. Once you answer (or skip), `docs/assets/VISUAL-IDENTITY.md` is authored and committed.
4. The full 9-step pipeline runs: audit, prose rewrite, SVG generation, public domain artwork fetch, quality pass, commit.

**Subsequent runs:**

Steps 1–2 are skipped. The pipeline reads your existing `VISUAL-IDENTITY.md` and runs Steps 3–9 directly.

---

## What gets committed

After a successful run, Claude commits to your repo with a message like:

```
docs: [repo-name] documentation refresh — YYYY-MM-DD

- 4 pages rewritten
- 1 page split into topic sub-pages: cli-reference.md
- 3 SVGs added: architecture.svg, install-flow.svg, commands.svg
- 2 images fetched: hero.jpg (Wikimedia Commons), contributing.jpg (Library of Congress)
- 0 visual placeholders remaining
- 1 GitHub Issue filed
```

All changes land in `docs/` and the root `README.md`. Nothing outside those paths is touched.

---

## Optional: richer design options with ui-ux-pro-max

The built-in art-direction skill produces a solid visual identity from scratch. If you want access to 50 curated styles, 21 palettes, and 50 font pairings as a starting point, install `ui-ux-pro-max`:

[https://skills.sh/nextlevelbuilder/ui-ux-pro-max-skill/ui-ux-pro-max](https://skills.sh/nextlevelbuilder/ui-ux-pro-max-skill/ui-ux-pro-max)

Once installed, the art-direction skill detects it automatically and offers it as an option before asking discovery questions.

---

## Tip: run it on this repo first

Before running it on a project you care about, try it on the `auto-spicy-github` repo itself:

```bash
cd ~/path/to/auto-spicy-github
claude
```

```
update the github documentation
```

You will see exactly what the pipeline produces — visual identity conversation, SVG output, prose rewrites, commit log — before it touches anything important. It is the fastest way to understand what you are working with.
