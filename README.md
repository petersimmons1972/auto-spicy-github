# auto-spicy-github

Give any GitHub repo beautiful, art-directed documentation with a single phrase.

## What it does

Say "update the github documentation" to Claude Code and it:
- Interviews you about your project's visual personality
- Rewrites all doc pages with personality and real examples
- Generates SVG diagrams and charts
- Fetches public domain artwork matched to your aesthetic
- Splits long pages into focused topic-driven sub-pages
- Commits everything with a structured message

## Install

```bash
git clone https://github.com/petersimmons1972/auto-spicy-github
cd auto-spicy-github
./install.sh
```

## Usage

In any Claude Code session, with your target repo open:

```
update the github documentation
```

That's it. Claude will ask which repo (if you haven't specified), then run the full pipeline.

## What gets installed

Three skills go into `~/.claude/skills/`:

- **github-docs** — the full documentation pipeline
- **visual-output-standards** — SVG and chart craft rules
- **art-direction** — visual identity discovery and management

## Bring your own design standard

Works best with a design skill installed. We recommend
[ui-ux-pro-max](https://skills.sh/nextlevelbuilder/ui-ux-pro-max-skill/ui-ux-pro-max) — 50 styles, 21 palettes, 50 font pairings. Install it and the pipeline will detect it automatically.

See [docs/design-standards.md](docs/design-standards.md) for details.

## Platform support

Native: Claude Code · Gemini CLI · Copilot CLI
Other platforms: see [ADAPTING.md](ADAPTING.md)
