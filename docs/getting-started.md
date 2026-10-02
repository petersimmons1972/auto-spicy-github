# Getting Started

![Installation flow](assets/svg/install-flow.svg)
*Clone, install, run the skill.*

## Prerequisites

[Claude Code](https://claude.ai/code), installed and authenticated.

## 1. Install

```bash
git clone https://github.com/petersimmons1972/auto-spicy-github
cd auto-spicy-github
./install.sh
```

The installer copies the `art-direction` skill into `~/.claude/skills/` and places a `VISUAL-IDENTITY.md` template beside it. `clearwatch-visual-standards` is not installed; the founder invokes it manually.

## 2. Open your target repo

```bash
cd ~/projects/your-repo
claude
```

## 3. Run the skill

Run `/art-direction`, or ask Claude to establish the repo's visual identity. If `docs/assets/VISUAL-IDENTITY.md` already exists it is read and reused; otherwise Claude asks four questions:

1. **Personality**: how should this repo feel?
2. **Aesthetic reference**: any era, movement, or visual style that resonates? (optional)
3. **Existing brand materials**: logo, hex codes, design system? (optional)
4. **Visual references**: repos or sites whose design you admire? (optional)

All four are optional. Claude authors `VISUAL-IDENTITY.md` from whatever you give it and commits it.

## Optional: richer starting palettes

Install [ui-ux-pro-max](https://skills.sh/nextlevelbuilder/ui-ux-pro-max-skill/ui-ux-pro-max) and `art-direction` detects it automatically and offers it before the discovery questions.
