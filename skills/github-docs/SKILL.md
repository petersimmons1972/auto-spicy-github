---
name: github-docs
description: "Use when the user wants a repo's GitHub documentation refreshed or updated. Runs the full documentation refresh pipeline: visual identity, prose rewrite, visual audit, SVG generation, public domain artwork, quality pass, commit."
---

# GitHub Documentation Update Pipeline

Trigger: the user asks to update or refresh a repo's GitHub documentation.

**Goal:** produce accurate, on-brand, well-illustrated GitHub documentation for the target repo — prose that reads as one confident author, every page illustrated to its type's needs, every fetched image license-clean, and the whole set committed only after the user confirms.

This skill runs the full documentation refresh for one repo, or for several when the user names them. Run it only on explicit request, never on every commit. **Docs scoping (hard boundary):** only touch files under `docs/` (prose, SVGs, images) — never modify application/source code outside that directory.

---

## Model & style policy (read before starting)

**Model:** Use the strongest general model available to you, and let the model decide per step how to spend effort — do NOT pin a specific model tier or persona to a specific step. Capability improves over time; a step that needed a heavyweight model yesterday may not tomorrow. Dispatch subagents where parallelism helps, but choose the model at dispatch time based on what's currently strongest, not a frozen table.

**Visual & style choices:** Derive them from the **target repo's own brand/visual-identity doc** — `docs/assets/VISUAL-IDENTITY.md`, or any design/brand docs the repo carries. That doc is the single source of truth for palette, typography mood, poster style, SVG constraints, and the period/subject/aesthetic that fetched artwork should match.

If the repo has **no** visual-identity doc, run the `art-direction` skill (the discovery conversation that authors `docs/assets/VISUAL-IDENTITY.md`) and commit the result before doing prose or visual work. If that skill is unavailable, author the doc yourself from the template below. If you cannot author one, fall back to sensible, tasteful defaults (legible type, a restrained palette, standard SVG dimensions) — but do NOT hardcode a per-repo aesthetic here; the repo owns its look.

### Visual Identity Template

```markdown
# Visual Identity: [REPO NAME]

## Theme
[1-sentence aesthetic statement — what does this repo LOOK like?]

## Palette
| Role       | Hex     | Usage                          |
|------------|---------|-------------------------------|
| Primary    | #...    | backgrounds, large elements   |
| Accent     | #...    | calls to action, highlights   |
| Text       | #...    | body text on dark backgrounds |

## Typography mood
[serif/sans, formal/casual, letter-spacing direction, weight preferences]

## Poster style
[Image-generation prompt fragment that applies to ALL posters in this repo.
 Include: medium, era, lighting, color treatment, mood words]

## Period / subject for fetched artwork
[Which historical period and subject matter public-domain images should match]

## SVG constraints
- viewBox: [standard dimensions — 750x420 landscape, 512x768 portrait, 600x600 square]
- Corner treatment: [rounded / sharp]
- Gradient style: [radial from center / linear top-to-bottom / flat]
- Font family: [serif / sans, with fallback]

## Existing assets
[List any committed SVGs or posters already in docs/assets/]
```

---

## Required outcomes (checklist — order not mandated)

Work through these until all are satisfied. You may reorder or interleave them as makes sense, but every box must be checked before you report done. The starred items are hard gates and safety boundaries — do not skip or weaken them.

- [ ] **Scope identified.** Which repo? If not specified, ask: "Which repo should I update? Or say 'all' to run on every git repo directly under the current working directory." For "all", run each repo found, in alphabetical order. Confirm the scope before doing work.
- [ ] **Visual identity resolved.** Load the target repo's visual-identity/brand doc. If absent, run `art-direction` (or author from the template above), commit it, or fall back to sensible defaults per the policy above.
- [ ] **Visual state audited.** For each `.md` in `docs/` (and the root `README.md`), count images, SVGs, and embedded charts; flag pages over 400 lines for splitting. Build an audit table (Page | Current visuals | Required | Gap | Type needed) using the visual requirements below. Pages below minimum (excluding changelog) get a `<!-- VISUAL: [description] -->` placeholder and a filed issue (`gh issue create --repo [owner/repo] --title "docs: [page] missing required visual" --body "[page path, visual type needed]" --label documentation`).
- [ ] **Prose rewritten.** Rewrite each doc page per the prose rules below. Match the repo's voice as defined in its visual-identity doc.
- [ ] **SVGs generated** for each page gap needing a diagram/chart. Load the `visual-output-standards` skill first, and follow the SVG rules below and the repo's palette/constraints. Commit to `docs/assets/svg/`.
- [ ] **Artwork sourced** for pages needing it — fetch public-domain images (real tool actions below) or fall back to a thematic SVG. ★ **Every fetched image must pass license verification** before it is committed.
- [ ] **Quality pass complete.** Review voice consistency (does it sound like one author?), visual spec accuracy (do SVGs match the palette?), visual-count compliance, and that each page carries one memorable idea. Fix issues inline.
- [ ] ★ **User confirmed.** Present the planned changes and get explicit user confirmation BEFORE committing or publishing anything. This pipeline may touch multiple repos — never commit without the go-ahead.
- [ ] ★ **Committed.** Stage all `docs/` changes and commit (message format below).
- [ ] ★ **Follow-up issues filed** for every remaining visual placeholder / unmet gap, and report to the user.

---

## Visual requirements by page type

| Page type | Minimum | Preferred format |
|-----------|---------|-----------------|
| README / landing | 1–2 | Poster/artwork + command table SVG |
| Getting started / install | 1 | Flow diagram SVG |
| CLI reference | 1 | Field-card SVG |
| Architecture / how it works | 1–2 | Architecture diagram SVG |
| Data/scoring/metrics | 1–3 | Charts (SVG preferred) |
| Contributing / philosophy | 1 | Poster/artwork only |
| Changelog | 0 | Data table, no visuals required |

---

## Prose rules

- Entertaining, example-rich, 2nd-person where natural
- Witty where the visual-identity theme allows — match the repo's voice
- No passive voice. No filler phrases ("This document explains...", "In order to...")
- Every code example must be real and runnable, not pseudocode
- Every flag and option in CLI docs must have an example invocation
- One defensible selling idea per page — what is the reader supposed to remember?

---

## SVG rules

- `viewBox` and `xmlns` required on every SVG
- Follow the repo's visual-identity palette exactly
- All text as `<text>` elements — no paths for readable text
- Gradient definitions in `<defs>` block
- Standard dims: 750×420 landscape, 512×768 portrait, 600×600 square
- For chart pages: prefer SVG bar/scatter/timeline built from actual data in the docs. If data isn't available, generate a representative example with clearly labeled axes and a note that values are illustrative.

---

## Sourcing artwork (real tool actions — do not skip)

For each page requiring artwork: search for and fetch a public-domain image that fits the page's theme and the repo's visual identity. Commit it to `docs/assets/posters/` and replace the `<!-- POSTER: -->` placeholder with a real `![caption](assets/posters/filename.jpg)` reference. Match the period and subject to the repo's visual identity (defined in its visual-identity doc), not to any table here.

### Search strategy

Prefer a local or self-hosted search tool when one is available (for example a SearxNG MCP tool); otherwise use your harness's built-in web search. Preferred sources (all have strong public domain collections):

- **Wikimedia Commons** — `site:commons.wikimedia.org [subject]`
- **Library of Congress** — `site:loc.gov/resource [subject]`
- **National Archives** — `site:catalog.archives.gov [subject]`
- **Europeana** — `site:europeana.eu [subject]`
- **Imperial War Museum** — `site:iwm.org.uk [subject]`

### License verification (hard gate)

Before fetching, confirm the image is:
- Public domain (pre-1928, US government work, or explicitly marked PD)
- Or CC0 / Creative Commons with no restrictions

Do not commit any image that fails this check.

### Fetch and commit

1. Fetch the direct image URL (full resolution, `.jpg` or `.png`) using whichever URL-fetch tool your harness provides (prefer a local reader tool if available).
2. Save to `docs/assets/posters/[page-slug].jpg`
3. Replace `<!-- POSTER: poster-[page-slug]-[purpose].jpg -->` in the doc with:
   ```markdown
   ![Caption](assets/posters/[page-slug].jpg)
   *Source: [attribution — title, creator, year, institution]*
   ```
4. Add source attribution in italics under the image

### If no suitable public domain image exists

Fall back to generating a thematic SVG illustration in the repo's visual identity style. Use the same SVG constraints as above. Save to `docs/assets/posters/[page-slug].svg` instead.

---

## Commit

★ Confirm with the user before committing — this pipeline may touch multiple repos. Then stage all `docs/` changes. Commit:

```
docs: [repo-name] documentation refresh — YYYY-MM-DD

- [N] pages rewritten
- [N] SVGs added: [list names]
- [N] images fetched: [list filenames + sources]
- [N] visual placeholders remaining (no public domain match found)
- [N] GitHub Issues filed
```

---

## Report to User

Before presenting this report, flag anything that looks wrong — mismatched licenses, an unexpectedly high placeholder count, or an audit table that doesn't add up.

```
## Documentation Refresh Complete — [repo-name]

Pages updated: N
SVGs committed: [list]
Images fetched: [list — filename, source, license]
Placeholders remaining: N (no public domain match — SVG fallback needed)
GitHub Issues filed: [list]
```
