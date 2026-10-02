# auto-spicy-github

Art direction skills for GitHub repos: establish a committed visual identity, and keep Clearwatch artwork on-brand.

## What it does

The `art-direction` skill:

- Interviews you about your project's visual personality (4 questions, all optional)
- Checks installed design skills (such as ui-ux-pro-max) as a starting reference
- Authors `docs/assets/VISUAL-IDENTITY.md` (palette, typography, imagery style, SVG constraints) with concrete values and commits it
- Steers away from stock default styles by naming them

The `github-docs` and `visual-output-standards` skills were retired (2026-10-02). Docs refresh and generic SVG craft are no longer part of this repo.

---

## Install

```bash
git clone https://github.com/petersimmons1972/auto-spicy-github
cd auto-spicy-github
./install.sh
```

`art-direction` lands in `~/.claude/skills/` and is available in any new Claude Code session, along with a `VISUAL-IDENTITY.md` template.

---

## Use

Open a repo in Claude Code and run `/art-direction`, or ask to establish or refresh the repo's visual identity.

---

## What is in the repo

| Skill | What it does |
|-------|-------------|
| `art-direction` | Visual identity discovery conversation; installed by `install.sh` |
| `clearwatch-visual-standards` | Standalone Clearwatch standard: SVG craft rules, palette, vendor colors, chart constants. Not installed by `install.sh`; the founder invokes it manually |

---

## Bring your own design standard

Works best with a design skill installed. [ui-ux-pro-max](https://skills.sh/nextlevelbuilder/ui-ux-pro-max-skill/ui-ux-pro-max) is the recommended default. Install it and `art-direction` detects it automatically, offering it as a starting point before the discovery questions.

See [docs/design-standards.md](docs/design-standards.md) for the priority chain.

---

## Platform support

**Native:** Claude Code · Gemini CLI · Copilot CLI

**Other platforms:** [ADAPTING.md](ADAPTING.md) explains how to inline the skill elsewhere.

---

## Requirements

- Claude Code (authenticated)
- Target repo open in a Claude Code session
