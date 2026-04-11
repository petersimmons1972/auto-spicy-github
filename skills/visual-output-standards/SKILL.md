---
name: visual-output-standards
description: "Universal visual quality standard for SVG, chart, and illustration output. Read BEFORE creating any SVG, chart, or illustration. Defines technical craft rules, aesthetic principles, and verification checklists. Palette and brand colors come from the project's VISUAL-IDENTITY.md — this skill enforces craft, not brand."
---

# Visual Output Standards

**This is the single source of truth for SVG and chart craft quality.** Every agent producing visual output reads this before touching a pixel. Palette and brand colors come from your project's `docs/assets/VISUAL-IDENTITY.md` — this skill enforces universal craft rules that apply regardless of project aesthetic.

---

## 1. Technical Pre-Flight Rules

These rules MUST be followed for every SVG. They catch the most common classes of visual failure.

### Font Size

| Context | Minimum |
|---------|---------|
| Chart data labels | 14px |
| Footnotes / source lines | 12px |
| Brand artwork SVGs | 11px at viewBox scale |
| Hero numbers / callouts | 42px |

**Font families:**

Use fonts from your `VISUAL-IDENTITY.md` typography section. If none specified, safe defaults:
- Display: `'Playfair Display', Georgia, serif`
- Body: `Inter, 'Segoe UI', sans-serif`
- Monospace: `'JetBrains Mono', 'Fira Code', monospace`

### Paint Order

Render elements in this sequence — no exceptions:

1. **Backgrounds** (fills, gradient fills)
2. **Geometry** (bars, arcs, polygons, grid lines)
3. **Strokes** (borders, benchmark dashes)
4. **Text** (labels, titles, annotations)

**Critical rule:** Never draw a text element before an opaque fill that overlaps its bounding box. This is the #1 class of bug that code review misses — the code is syntactically correct but the z-order causes occlusion. Verify explicitly after computing layout.

### Geometry on a Horizontal Baseline — Use Upper Semicircles, Not Full Circles

When you need a decorative disc or round motif whose diameter sits ON a horizontal element (a platform bar, a base line, a rule), **build it as upper-semicircle `<path>` arcs, not full `<circle>` elements.**

**Why:** SVG uses a y-down coordinate system. A `<circle cx="600" cy="650" r="45">` drawn before a platform bar at `y=650` will have its upper half above the bar (visible) AND its lower half below the bar (also visible). The result is a disc hanging BELOW the bar, not sitting ON it.

**Correct construction:**

```svg
<!-- Upper half-disc sitting on y=650 -->
<path d="M 555,650 A 45,45 0 0 1 645,650 Z" fill="#D4AF37"/>
```

The arc goes from `(x - r, y)` to `(x + r, y)` with `large-arc-flag=0` and `sweep-flag=1`. Clockwise sweep on a y-down canvas produces an arc bulging UPWARD. The `Z` closes the path at the baseline.

**Verify:** After generating the arc, mentally sweep from start to end. On a y-down canvas with sweep-flag=1, clockwise from `(x-r, y)` to `(x+r, y)` is upward.

**Never:** Use a full `<circle>` for any decorative element whose center sits on a horizontal element drawn after it.

### Text Container Margins

Agents cannot measure actual font metrics. All text containers MUST include **25% padding** beyond the estimated text width.

**Text width estimation:**
- Regular text: `font_size * 0.52` px per character
- Bold text: `font_size * 0.62` px per character

If estimated text width exceeds 75% of the container, the text WILL overflow on some browsers. Shrink font, abbreviate, or widen the container.

### SVG Character Set

**ASCII only** in SVG text elements. No Unicode special characters (bullets, arrows, check marks, em dashes). Build visual markers from SVG primitives: `<circle>` for bullets, `<line>` or `<path>` for arrows, `<rect>` + color fill for status indicators.

**Why:** Unicode glyphs render inconsistently across font stacks and browsers.

### Polygon and Geometric Layout

All polygon vertices MUST be computed from a single stated center point. No eyeballed coordinates. If you cannot state the center `(cx, cy)` and the computation for each vertex, the geometry is unverifiable.

### ViewBox and Namespace

Every SVG root element MUST have:
- `viewBox="0 0 [width] [height]"` — defines the coordinate space
- `xmlns="http://www.w3.org/2000/svg"` — required for standalone SVG files
- `width="100%"` — enables responsive scaling in HTML contexts

Standard dimensions:
- Landscape diagram: `viewBox="0 0 750 420"`
- Portrait poster: `viewBox="0 0 512 768"`
- Square icon: `viewBox="0 0 600 600"`

Match viewBox to the context you are rendering in. State the effective rendering width in your plan before writing the SVG.

### Post-Creation Verification Checklist

After generating ANY SVG, verify:
1. All text elements >= minimum font size for the context
2. No opaque fill element occludes a text element drawn earlier
3. All polygons are centered on their stated center point
4. No content rendered outside the viewBox boundary
5. No text truncated at SVG edges (check right and bottom margins)
6. Contrast ratio >= 4.5:1 on all text (WCAG AA)

---

## 2. Color and Palette

**Your palette comes from `docs/assets/VISUAL-IDENTITY.md`, not from this skill.**

This skill enforces these universal palette rules:

- Use exactly the colors defined in your `VISUAL-IDENTITY.md`. Do not improvise new colors.
- Every color used must have a named role (Primary, Accent, Text, Muted, etc.)
- Contrast ratio >= 4.5:1 on all text against its background (WCAG AA)
- When in doubt whether a color is legible: it probably is not. Use a higher-contrast alternative.

**Accent color usage:** Accent colors should mark insight and emphasis, not decoration. When an accent color appears, it should mean "pay attention here." Using it for decorative borders or background fills dilutes the signal.

---

## 3. Aesthetic Principles

These separate intentional visual design from generic output. Technical compliance is necessary but not sufficient.

### Data Density

Every pixel earns its place. No decorative gradients, drop shadows, or background textures that do not carry information. A bar chart with 4 bars does not need a 1400x800px canvas — it needs a well-framed, smaller canvas.

### Deliberate Whitespace

Margins are intentional framing, not wasted space. Charts that breathe feel authoritative. Charts that fill every pixel feel cluttered.

Minimum recommended margins:
- Top: 50px (title clearance)
- Bottom: 60px (x-axis labels + footnotes)
- Left: 70px (y-axis labels)
- Right: 20px (edge buffer)

### Verdict-First Titles

Every chart title states the finding, not the topic. The title is a sentence, not a label.

| Fails | Passes |
|-------|--------|
| "Capability Comparison" | "Team A Outperforms on Throughput, Team B Wins on Latency" |
| "Performance Over Time" | "Response Time Improved 43% After Cache Layer Added" |
| "User Retention" | "Weekly Active Users Up 28% Since Onboarding Redesign" |

**Metric requirement:** Every verdict-first title should contain at least one specific metric (%, time, count, ratio). A title without a number is an opinion.

### Parity Is Information

When two values are within 10% of each other, the chart MUST either:
1. Display a visible **PARITY** callout explaining WHY the tie matters, OR
2. Be removed and replaced with one sentence.

Silence on a tie is worthless to a reader making a decision.

### Business Value Annotation

Every chart or diagram benefits from a plain-language caption immediately below:

```markdown
![Chart description](assets/svg/chart.svg)
*What this shows: [one sentence about the decision this informs]*
```

The annotation answers: "What should I do differently because of this?" Not "what data does this show."

### Magazine-First Rule

When choosing between visualization approaches, prefer the one that would look at home in a printed magazine. If it looks like a homework assignment, redesign it.

---

## 4. Chart Dimensions

| Parameter | Value |
|-----------|-------|
| Minimum size | 600x400px |
| Maximum size | 1400x800px |
| Preferred aspect ratio | 1.5:1 to 2:1 |
| Default landscape | 750x420px |
| Default portrait | 512x768px |
| Default margin | 60px (adjust to content) |

Scale the canvas to the content, not the other way around. A 4-bar chart should be ~600x350px, not 1310x620px.

---

## 5. Data Integrity Rules

- Fallback defaults must **fail loud, not silent**. Never use a plausible-looking hardcoded number when data is missing.
- Every missing-data state must produce a visible "DATA MISSING" label or equivalent — not a blank space.
- **Triage by decision impact.** A chart that could mislead a real decision is higher priority than cosmetic issues.

---

## 6. Artwork Workflow

For illustrations, posters, and visual content:

1. **Before creating:** Read this entire skill. All rules are hard requirements.
2. **State the rendering context** in your plan: target platform, viewBox dimensions, effective rendering width.
3. **Create the artwork** following Sections 1-3 above.
4. **Verify** against the Post-Creation Checklist (Section 1).
5. **Human reviews** the rendered output as final gate.

---

## 7. Learning Protocol

When any chart or illustration fails review:

1. **File a GitHub Issue** — label with `visual-quality` + severity
2. **Write the rule** that would have prevented it — add it to this skill under the relevant section
3. **Close the issue** referencing the skill update commit
4. **Do NOT store quality rules in conversation history or memory** — rules live here only

This skill grows over time. Every failure makes the next creation better.
