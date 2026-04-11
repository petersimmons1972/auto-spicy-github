---
name: github-docs
description: "Use when the user says 'update the github documentation' or any equivalent phrase (update the docs, refresh the GitHub pages, update docs for X). Runs the full documentation refresh pipeline: visual identity, prose rewrite, SVG generation, public domain artwork, quality pass, commit."
---

# GitHub Documentation Update Pipeline

Trigger: user says **"update the github documentation"** or any equivalent phrase.

This skill runs the full documentation refresh pipeline for one or all repos. Do NOT run this on every commit — only on explicit trigger.

---

## Step 1: Identify Scope

Which repo? If not specified in the user's message, ask:

> "Which repo should I update? Or say 'all' to run on every repo in your current working directory."

If "all": scan direct subdirectories of the current working directory for folders containing a `.git` directory. Run for each one found, in alphabetical order by directory name.

---

## Step 2: Load Visual Identity

Read `docs/assets/VISUAL-IDENTITY.md` in the target repo.

**If it does not exist:** Load the `art-direction` skill to run the visual identity discovery conversation. Do NOT proceed to prose or SVG work until `docs/assets/VISUAL-IDENTITY.md` is created and committed.

```
Skill("art-direction")
```

**If the `art-direction` skill is unavailable:** Ask the user to create `docs/assets/VISUAL-IDENTITY.md` manually using the template at `templates/VISUAL-IDENTITY.md` in the auto-spicy-github repo, then re-run this pipeline.

---

## Step 3: Audit Current Visual State

For each `.md` file in `docs/` (and the root `README.md`): count images, SVGs, and embedded charts. Also flag pages over 400 lines for splitting.

Build an audit table:

| Page | Lines | Current visuals | Required | Gap | Action needed |
|------|-------|----------------|----------|-----|---------------|

Visual requirements by page type:

| Page type | Minimum | Preferred format |
|-----------|---------|-----------------|
| README / landing | 1-2 | Hero image/artwork + command table SVG |
| Getting started / install | 1 | Flow diagram SVG |
| CLI reference | 1 | Field-card SVG |
| Architecture / how it works | 1-2 | Architecture diagram SVG |
| Data/scoring/metrics | 1-3 | Charts (SVG preferred) |
| Contributing / philosophy | 1 | Poster/artwork |
| Changelog | 0 | No visuals required |

Pages with 0 visuals (excluding changelog) get a `<!-- VISUAL: [description] -->` placeholder inserted. File a GitHub Issue in the target repo using: title "docs: [page name] missing required visual", body listing the page path and visual type needed, label `documentation`. Use `gh issue create --repo [owner/repo] --title "..." --body "..." --label documentation`.

Pages over 400 lines get flagged in the audit table with action "SPLIT" — they will be broken into topic-driven sub-pages in Step 4.

---

## Step 4: Prose Pass

Rewrite each doc page. Rules:

- Entertaining, example-rich, 2nd-person where natural
- Match the voice and personality defined in `VISUAL-IDENTITY.md`
- No passive voice. No filler phrases ("This document explains...", "In order to...")
- Every code example must be real and runnable — no pseudocode
- Every flag and option in CLI docs must have an example invocation
- Narrative/philosophy pages: write with genuine voice and concrete specifics
- Technical reference pages (CLI, architecture): prioritize accuracy and scannability over prose

**Splitting long pages:**

For any page flagged "SPLIT" in the audit:
1. Identify natural topic breaks (## headings or logical groupings)
2. Create one sub-page per topic under `docs/[topic-name].md`
3. Replace the original page content with a navigation hub:
   - 1-2 sentence summary of each sub-page
   - Link to each sub-page
   - Keep any essential overview content (first 100 lines or so)
4. The original file becomes the index — it should be short and scannable

Example: a 600-line `README.md` with sections Installation, Configuration, CLI Reference, Architecture, FAQ becomes:
- `README.md` (80-line navigation hub)
- `docs/installation.md`
- `docs/configuration.md`
- `docs/cli-reference.md`
- `docs/architecture.md`
- `docs/faq.md`

---

## Step 5: SVG Generation

For each page gap requiring a diagram or chart: generate SVG code directly. Commit to `docs/assets/svg/`.

**Before generating any SVG, load:**
```
Skill("visual-output-standards")
```

SVG rules (summary — the skill has the full detail):
- `viewBox` and `xmlns` required on every SVG
- Follow `VISUAL-IDENTITY.md` palette exactly
- All text as `<text>` elements — no paths for readable text
- Gradient definitions in `<defs>` block
- Standard dims: 750x420 landscape, 512x768 portrait, 600x600 square

For chart pages: prefer SVG bar/scatter/timeline built from actual data in the docs. If data is not available, generate a representative example with clearly labeled axes and a note that values are illustrative.

---

## Step 6: Artwork (fetch from web)

For each page requiring artwork: search for and fetch a public domain image that fits the page's theme and the repo's visual identity from `VISUAL-IDENTITY.md`. Commit it to `docs/assets/posters/` and replace the `<!-- VISUAL: -->` placeholder with a real image reference.

### Search strategy

Use WebSearch to find images. Preferred sources (all have strong public domain collections):

- **Wikimedia Commons** — `site:commons.wikimedia.org [subject]`
- **Library of Congress** — `site:loc.gov/resource [subject]`
- **National Archives** — `site:catalog.archives.gov [subject]`
- **Europeana** — `site:europeana.eu [subject]`

### License verification

Before fetching, confirm the image is:
- Public domain (pre-1928, US government work, or explicitly marked PD)
- Or CC0 / Creative Commons with no restrictions

### Fetch and commit

1. WebFetch the direct image URL (full resolution, `.jpg` or `.png`)
   - If the fetch fails (network error, 404, or non-image response): log the failure, skip this image, and fall back to the SVG fallback path below — do not retry the same URL
2. Save to `docs/assets/posters/[page-slug].jpg`
3. Replace `<!-- VISUAL: ... -->` in the doc with:
   ```markdown
   ![Caption](assets/posters/[page-slug].jpg)
   *Source: [attribution — title, creator, year, institution]*
   ```

### Matching artwork to the project

Match the artwork subject and period to the project's `VISUAL-IDENTITY.md` imagery style. The visual identity doc tells you what kinds of images suit this project — honor it.

### If no suitable public domain image exists

Fall back to generating a thematic SVG illustration in the repo's visual identity style (using `visual-output-standards` and `VISUAL-IDENTITY.md` palette). Save to `docs/assets/posters/[page-slug].svg`.

---

## Step 7: Quality Pass

Review all updated pages with an advertising strategist's eye:

- **Voice consistency:** Do all pages sound like one author? Does the voice match the personality defined in `VISUAL-IDENTITY.md`?
- **Visual spec accuracy:** Do SVGs use the correct palette from `VISUAL-IDENTITY.md`?
- **Visual count compliance:** Is every non-changelog page above the minimum? Any missing placeholders?
- **One defensible idea per page:** What is the reader supposed to remember after reading each page? If you cannot answer that in one sentence, the page needs more focus.

Fix issues inline before committing. If a quality issue requires regenerating an SVG, return to Step 5 and regenerate only that asset. If it requires re-fetching an image, return to Step 6 for that page only. Do not re-run the full pipeline — targeted fixes only. If a quality issue cannot be resolved inline (e.g., the source data needed for a chart is unavailable), insert a `<!-- VISUAL: [description of unresolvable issue] -->` placeholder, file a GitHub Issue, and continue to commit.

---

## Step 8: Commit

Stage all `docs/` changes. Commit:

```
docs: [repo-name] documentation refresh — YYYY-MM-DD

- [N] pages rewritten
- [N] pages split into topic sub-pages: [list]
- [N] SVGs added: [list names]
- [N] images fetched: [list filenames + sources]
- [N] visual placeholders remaining (no public domain match found)
- [N] GitHub Issues filed
```

---

## Step 9: Report to User

```
## Documentation Refresh Complete — [repo-name]

Pages updated: N
Pages split: [list originals and sub-pages created]
SVGs committed: [list]
Images fetched: [list — filename, source, license]
Placeholders remaining: N (SVG fallback needed — no public domain match found)
GitHub Issues filed: [list]
```
