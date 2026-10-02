---
name: clearwatch-visual-standards
description: Clearwatch palette, vendor colors, chart constants and chart-type rules. Use together with visual-output-standards when producing charts or brand artwork for Clearwatch (reports, Substack, LinkedIn); not for other projects.
---

# Clearwatch Visual Standards (overlay)

This is the Clearwatch-specific layer on top of the generic `visual-output-standards` skill. Load `visual-output-standards` first for the universal SVG craft rules (paint order, geometry, character set, XML comment syntax, checklist), then apply the Clearwatch palette, constants and chart rules below. For any other project, use that project's own `docs/assets/VISUAL-IDENTITY.md` instead and do not load this skill.

The constants below exist in the Clearwatch repo (`pipeline/design_constants.py`, `pipeline/validators/chart_preflight_check.py`) and are enforced there for charts; for brand artwork, verify manually.

---

## 1. Clearwatch Type Constants

| Context | Minimum | Source |
|---------|---------|--------|
| Clearwatch charts | 14px | `design_constants.MIN_FONT_SIZE_PX` |
| Footnotes/source lines | 12px | `design_constants.CHART_FOOTNOTE_FLOOR` |
| Brand artwork SVGs | 11px at viewBox scale | Substack/LinkedIn render testing |
| Hero numbers | 42px | `design_constants.HERO_NUMBER_SIZE` |
| Callout text | 16px | `design_constants.CALLOUT_SIZE` |

**Font families:**
- Display: `Kufam, 'Playfair Display', Georgia, serif`
- Body: `Inter, 'Source Sans 3', 'Segoe UI', sans-serif`

---

## 2. Clearwatch Color Identity

### Core Palette

| Role | Hex | Name | Usage |
|------|-----|------|-------|
| 🔵 Background | `#0F172A` | Navy | All chart backgrounds, report dark mode |
| ⚫ Light background | `#243B55` | Navy Light | Subtle differentiation on navy |
| ⚪ Primary text | `#f8fafc` | Cream | All primary labels, titles, data values |
| ⚪ Secondary text | `#94a3b8` | Gray | Annotations, axis labels, subtitles |
| ⚫ Muted text | `#64748b` | Gray Dark | Footnotes, source attributions only |
| ⚫ Grid/decorative | `#334155` | Grid | Grid lines, borders — NEVER for text |
| 🟡 Gold accent | `#FFAF18` | Gold | Callout badges, highlight bars, parity indicators |
| 🟡 Gold annotation | `#D4A574` | Gold Dim | Verdict backgrounds, editorial callouts |

### Banned Text Colors on Navy

These colors are illegible on `#0F172A` background. NEVER use as text fill:

`#475569` `#4b5563` `#555` `#666` `#555555` `#666666` `#374151` `#4a5568` `#6b7280`

If you're considering a text color and it's not in the palette above — it's probably wrong. Use `#94a3b8` (gray) or `#f8fafc` (cream).

### Vendor Colors (NON-NEGOTIABLE)

| Vendor | Hex | Semantic | Swatch |
|--------|-----|----------|--------|
| CrowdStrike | `#F59E0B` | Amber — challenger | 🟡 |
| SentinelOne | `#10B981` | Green — contender | 🟢 |
| Microsoft Defender | `#60a5fa` | Blue — neutral incumbent | 🔵 |
| Palo Alto Cortex | `#A78BFA` | Violet — premium enterprise | ⚫ |
| Risk / "You Handle" | `#EF4444` | Red — danger indicator | ❌ |
| Clearwatch / Annotations | `#D4A574` | Gold — editorial voice | 🟡 |

**Gradient convention:** Vendor bars use linear gradient, same hex color, opacity `0.9 -> 0.45`, left-to-right. Never solid fill for vendor comparison bars.

### Contrast Requirements

- Minimum contrast ratio: **4.5:1** (WCAG AA)
- Dark threshold: RGB component < 64 = "dark"
- Minimum chart padding: 15%
- Minimum data fill: 55% of viewBox

---

## 3. Aesthetic Principles — "Clearwatch Premium"

These define what separates a Clearwatch chart from generic AI output. Technical compliance is necessary but not sufficient.

### Data Density

Every pixel earns its place. No decorative gradients, drop shadows, or background textures that don't carry information. A bar chart with 4 bars doesn't need a 1400x800px canvas — it needs a 700x400px canvas with clear whitespace framing the data.

### Deliberate Whitespace

Margins are intentional framing, not wasted space. The navy background IS the design element. Charts that fill every pixel feel cluttered. Charts that breathe feel authoritative.

**Margins for Clearwatch charts:**
- Top: 50px (title clearance)
- Right: 20px (edge buffer)
- Bottom: 60px (x-axis labels + breathing room)
- Left: 70px (y-axis labels and title)
- Bottom safe margin: 30px (source footnotes must not clip in PDF)

### Gold as Annotation, Not Decoration

`#FFAF18` and `#D4A574` mark **insight** — a parity callout, a verdict badge, an editorial annotation. They draw the eye to the finding. Using gold for decorative borders, background fills, or non-semantic elements dilutes the signal. When gold appears, it should mean "the analyst is pointing at something."

### Verdict-First Titles

Every chart title states the finding, not the topic. The title is a sentence, not a label.

| ❌ Fails | ✅ Passes |
|----------|----------|
| "Capability vs. Operational Simplicity" | "Microsoft E5 Wins on Capability Count, CrowdStrike Wins on Operational Simplicity" |
| "Palo Alto Simpler to Operate" | "Palo Alto Cuts Admin Overhead 65% (18 vs 65 weekly hours)" |
| "Pricing Comparison" | "SentinelOne Complete Costs 38% Less at 500 Endpoints ($4.20 vs $6.80/ep/mo)" |

**Metric requirement:** Every verdict-first title MUST contain >=1 specific metric (%, $, hours, count). A title without a number is an opinion, not a finding.

### Parity Is Information

When two vendors score within 10% (`PARITY_THRESHOLD_PCT = 0.10`), silence is a failure. The chart MUST either:
1. Display a visible **PARITY** callout (gold badge) AND prose explaining WHY the tie matters to the buyer, OR
2. Be removed entirely and replaced with one sentence.

Silence on a tie is worthless to a buyer deciding between two vendors. Arguing WHY the tie matters is the value.

### Business Value Annotation

Every chart container includes a plain-text annotation immediately below:

```html
<div class="chart-container">[SVG chart]</div>
<p class="chart-annotation"><em>What this answers: [one sentence about the business decision]</em></p>
```

The annotation answers: "What business decision does this help me make?" Not "what data does this show."

### Magazine-First Rule

When choosing between a standard bar chart and an alternative visualization, prefer the one that would look at home in a printed magazine layout. If a chart looks like a homework assignment, redesign it.

---

## 4. Chart-Type-Specific Rules

### Market Constellation
- NEVER use tiny dots (r < 30) — they disappear on the page
- Use large blobs (r >= 54)
- SMB zone fill-opacity >= 0.18
- Vendor names font-size >= 14

### Vendor Radar / Capability Comparison
- NEVER draw multiple vendor polygons overlapping in a single hexagon (unreadable)
- Draw separate side-by-side mini hexagons, one per vendor, each self-contained

### Decision Sankey
- NEVER hardcode a specific vendor name in routes that appear on every report
- Use generic labels ("Existing Stack (any vendor)") for non-specific routes

### Capability Quadrant
- X-axis label: "Operational Simplicity" (NOT "Ease of Use")

---

## 5. Chart Dimensions

| Parameter | Value | Source |
|-----------|-------|--------|
| Default width | 1310px | `design_constants.CHART_DEFAULT_WIDTH` |
| Default height | 620px | `design_constants.CHART_DEFAULT_HEIGHT` |
| Default margin | 100px | `design_constants.CHART_DEFAULT_MARGIN` |
| Legend extra height | 60px | `design_constants.LEGEND_EXTRA_HEIGHT` |
| Bottom safe margin | 30px | `design_constants.CHART_BOTTOM_SAFE_MARGIN` |
| ViewBox width | 1310px | `design_constants.STANDARD_VIEWBOX_WIDTH` |
| Minimum size | 600x400px | Readability floor |
| Maximum size | 1400x800px | Not overwhelming |
| Aspect ratio | 1.5:1 to 2:1 | Preferred range |

**Exception:** `vendor_radar` uses 756px width (compact multi-panel layout).

---

## 6. Data Integrity Rules

- Fallback defaults must **fail loud, not silent**. Never use a plausible-looking hardcoded number when data extraction fails.
- Every fallback must: log a WARNING, produce "DATA MISSING" label, or raise an exception.
- **Triage by decision impact, not defect count.** A chart that obscures a cost figure is higher priority than 20 charts with 5px label clipping — because the buyer makes a wrong decision from the first.

---

## 7. Brand Artwork Workflow (LinkedIn, Substack)

For illustrations, diagrams, and visual content outside the Clearwatch automated pipeline:

1. **Before creating:** Read this entire skill. All rules are hard requirements, not suggestions.
2. **State the rendering context** in your opening plan: target platform, viewBox dimensions, effective rendering width.
3. **Create the artwork** following the generic craft rules and Sections 1-3 above.
4. **Run render check:** `bin/render-check.sh <output-file>` — confirms text clipping, occlusion, and contrast.
5. **Then call Ramsay** for code quality confirmation. Ramsay is the code gate; you already passed the render gate.
6. **Human reviews** the rendered output as final gate.

---

## 8. Learning Protocol

When any chart or illustration fails review:

1. **File GitHub Issue** — label `visual-quality` + severity
2. **Write the rule** that would have prevented it — add to this skill under the relevant section
3. **If machine-checkable** — add assertion to `ChartPreflightCheck` (pipeline) or `bin/render-check.sh` (brand artwork)
4. **Close the issue** referencing both the skill update commit and code change

This skill grows over time. Every failure makes the next creation better.

---

## Cross-Reference

| What | Where | Role |
|------|-------|------|
| This skill | `visual-output-standards` skill (generic craft) plus this overlay (Clearwatch palette/constants) | Canonical rules (prose) |
| `design_constants.py` | `pipeline/design_constants.py` | Machine-readable constants |
| `ChartPreflightCheck` | `pipeline/validators/chart_preflight_check.py` | Runtime enforcement |
| `bin/render-check.sh` | `bin/render-check.sh` | Manual render validation |
| `CHART-STANDARDS.md` | `domain-knowledge/CHART-STANDARDS.md` | Chart-count minimums, priority order, banned charts |
| `svg_geometry.py` | `pipeline/validators/svg_geometry.py` | Gate 19: overlap detection (post-render) |
| `chart_title_validator.py` | `pipeline/validators/chart_title_validator.py` | Gate 28: title quality |
