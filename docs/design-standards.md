# Design Standards

## How the pipeline picks a visual standard

Every time the `github-docs` pipeline runs, Step 2 resolves the visual standard before any prose or SVG work begins. The resolution order is:

```
VISUAL-IDENTITY.md (in the target repo)
    |
    | exists? use it. done.
    v
Installed design skill (ui-ux-pro-max or equivalent)
    |
    | found? offer it to the user before the discovery conversation
    v
Discovery conversation (art-direction skill)
    |
    v
VISUAL-IDENTITY.md authored from scratch and committed
```

`VISUAL-IDENTITY.md` always wins if it exists. The pipeline reads it and proceeds — no questions asked. Edit it to change the visual direction.

If it does not exist, the `art-direction` skill runs and creates it. After that first run, the file is committed and all future runs use it directly.

---

## What ui-ux-pro-max provides

`ui-ux-pro-max` is a design intelligence skill from skills.sh with:

- **50 named styles** — ranging from Swiss International to Brutalist to Cottagecore, each with defined visual rules
- **21 palettes** — purposefully composed, production-tested color systems
- **50 font pairings** — serif/sans, display/body, formal/casual

Without it, the art-direction skill generates a palette and typography system from scratch based on your answers. That works well. With `ui-ux-pro-max`, you get pre-composed options that have been used across many projects — faster to choose, less to specify.

It is the recommended starting point if you do not have a strong existing visual preference or an established brand system.

Listing and install instructions: [https://skills.sh/nextlevelbuilder/ui-ux-pro-max-skill/ui-ux-pro-max](https://skills.sh/nextlevelbuilder/ui-ux-pro-max-skill/ui-ux-pro-max)

---

## Installing ui-ux-pro-max

Follow the install instructions at the skills.sh listing linked above. The skill installs into `~/.claude/skills/` alongside the auto-spicy-github skills.

Once installed, the `art-direction` skill detects it automatically in Step 1 of the discovery conversation:

> "I found ui-ux-pro-max installed. Would you like to use it as your visual design reference?"

You can say:
- **yes** — pull palette and typography directly from it as the design foundation
- **no** — run the discovery conversation and build a custom identity from scratch
- **both** — answer the discovery questions, then select the specific style and palette from ui-ux-pro-max that best matches your answers

---

## Bringing your own design standard

Any skill with "design", "ui", "ux", or "visual" in its name or description — installed in `~/.claude/skills/` — will be detected by the art-direction skill.

If you have a proprietary design system packaged as a Claude Code skill, put it in `~/.claude/skills/` and it will be offered as a reference during visual identity discovery. The skill does not need to be from skills.sh.

If multiple matching skills are installed, the art-direction skill lists all of them and asks you to choose one before continuing.

---

## Relationship between VISUAL-IDENTITY.md and design skills

A design skill is a reference — a vocabulary of options. `VISUAL-IDENTITY.md` is the committed decision for this specific repo.

The workflow is:
1. Use a design skill (or the discovery conversation) to arrive at specific choices: a palette, a type system, a visual personality.
2. Those choices get written into `docs/assets/VISUAL-IDENTITY.md` with concrete hex codes, font names, and SVG constraints.
3. From that point forward, all SVG generation and artwork selection runs from `VISUAL-IDENTITY.md` — not from the design skill.

This means you can uninstall `ui-ux-pro-max` after running the art-direction conversation and your visual identity is fully preserved in the committed file. The design skill is a starting point, not a runtime dependency.

To change the visual direction of a repo later, either edit `VISUAL-IDENTITY.md` directly or delete it and re-run the pipeline to go through the discovery conversation again.
