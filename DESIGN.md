---
name: Practice Pulse 2.0
description: An owner's ledger book for a five-office dental group, footed, adjusted and reconciled to the cent.
colors:
  ledger-paper: "#e9efdf"
  sheet: "#f3f6ec"
  feint-rule: "#cbd9bd"
  margin-rule: "#9bb88f"
  printed-green: "#2c5a37"
  printed-green-soft: "#46704f"
  ink: "#1b1f1a"
  ink-faded: "#434b41"
  ink-pencil: "#5d685a"
  red-ink: "#b4231b"
  night-paper: "#101612"
  night-sheet: "#151d18"
  night-feint-rule: "#253229"
  night-margin-rule: "#3d5545"
  night-green: "#8fc79a"
  night-green-soft: "#79b085"
  night-ink: "#e5ede0"
  night-ink-faded: "#bac6b6"
  night-ink-pencil: "#8f9d8b"
  coral-ink: "#ff7a6e"
typography:
  display:
    fontFamily: "Zilla Slab, Georgia, serif"
    fontSize: "clamp(34px, 5vw, 54px)"
    fontWeight: 700
    lineHeight: 1
    letterSpacing: "-0.01em"
  headline:
    fontFamily: "Zilla Slab, Georgia, serif"
    fontSize: "25px"
    fontWeight: 700
    lineHeight: 1.15
  title:
    fontFamily: "Zilla Slab, Georgia, serif"
    fontSize: "18px"
    fontWeight: 700
  column-head:
    fontFamily: "Zilla Slab, Georgia, serif"
    fontSize: "15px"
    fontWeight: 700
    lineHeight: 1.2
  memorandum:
    fontFamily: "Karla, system-ui, sans-serif"
    fontSize: "clamp(18px, 1.9vw, 22px)"
    fontWeight: 500
    lineHeight: 1.45
  body:
    fontFamily: "Karla, system-ui, sans-serif"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.55
  figure:
    fontFamily: "Overpass Mono, ui-monospace, Menlo, monospace"
    fontSize: "14.5px"
    fontWeight: 400
    fontFeature: "tnum"
  label:
    fontFamily: "Overpass Mono, ui-monospace, Menlo, monospace"
    fontSize: "11.5px"
    fontWeight: 600
    letterSpacing: "0.06em"
  category:
    fontFamily: "Overpass Mono, ui-monospace, Menlo, monospace"
    fontSize: "12px"
    fontWeight: 700
    letterSpacing: "0.08em"
rounded:
  none: "0px"
spacing:
  cell-y: "8px"
  cell-x: "12px"
  panel: "14px 16px 12px"
  gutter: "28px"
  section: "34px"
  page: "28px 24px 56px"
  page-phone: "18px 16px 44px"
components:
  select:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.ink}"
    rounded: "{rounded.none}"
    padding: "8px 30px 8px 10px"
    height: "42px"
  tag-synthetic:
    textColor: "{colors.printed-green}"
    typography: "{typography.label}"
    rounded: "{rounded.none}"
    padding: "2px 7px"
  ledger-sheet:
    backgroundColor: "{colors.sheet}"
    rounded: "{rounded.none}"
  ledger-column-head:
    textColor: "{colors.printed-green}"
    typography: "{typography.column-head}"
    padding: "12px 12px 8px"
  ledger-cell:
    textColor: "{colors.ink}"
    typography: "{typography.figure}"
    padding: "8px 12px"
  panel:
    backgroundColor: "{colors.sheet}"
    rounded: "{rounded.none}"
    padding: "{spacing.panel}"
---

# Design System: Practice Pulse 2.0

## Overview

**Creative North Star: "The Owner's Ledger Book"**

The page is a columnar accounting pad, not an admin dashboard. Pale ledger-green paper carries a framed sheet of feint rules; heads are printed in green slab type, figures are written in black mono ink, and losses go in red ink inside parentheses. Footings get double rules. The vocabulary is bookkeeping throughout: memorandum, journal, sub-ledger, adjusting entries, reconciliation, an auditor's tick.

Density is a ledger's density: many figures, tight rows, nothing ornamental. Depth is paper on paper, framed by a 1.5px printed-green line, never lifted. Dark mode is the same book at night: green-black paper, soft green print, coral red ink. It is a distinct world from the rest of the portfolio, and it must never slide toward a generic SaaS admin look.

**Key Characteristics:**
- Ledger-green paper, green printed heads, black ink figures, red ink for losses.
- Three faces with fixed jobs: Zilla Slab heads, Karla prose, Overpass Mono figures.
- Square 1.5px frames, feint 1px rules, 3px double rules under footings.
- Flat everywhere: no shadows, no radius.
- Every mark is labelled; the data is labelled synthetic at the head and the foot.

## Colors

A near-monochrome green book with one red ink, mirrored for dark.

### Primary
- **Printed Green** (printed-green; night-green in dark): headings, column heads, sheet and panel frames, double rules under the head and footer, filled collections bars, the auditor's tick, focus ring.
- **Soft Print Green** (printed-green-soft; night-green-soft): a second green for adjacent fills, such as new-patient bars and the supplies segment.

### Secondary
- **Red Ink** (red-ink; coral-ink in dark): losses and negative differences only, always with parentheses. In the journal it fills the collections bar for a month at a loss, and the key gains a "Month at a loss" entry.

### Neutral
- **Ledger Paper** (ledger-paper; night-paper): the page ground.
- **Sheet** (sheet; night-sheet): framed ledger, panels, selects, tooltips, sticky row labels.
- **Feint Rule** (feint-rule; night-feint-rule): row and column rules, chart gridlines.
- **Margin Rule** (margin-rule; night-margin-rule): heavier structural rules, including the row-label margin, the Group column rule-off, category underlines and the memorandum underline.
- **Ink / Faded Ink / Pencil** (ink, ink-faded, ink-pencil and night equivalents): figures and prose; sub-lines and captions; change figures, axis labels, PMS names and picker labels.
- **Wash** (`rgba(44,90,55,.08)` light, `rgba(143,199,154,.08)` dark): marks the selected office column and the hovered journal month.

### Named Rules
**The Red Ink Rule.** Red means a loss or a variance, nothing else, and a negative always also carries parentheses so colour never carries the meaning alone.

**The Green Tint Rule.** Additional categorical fills are mixed from printed green into the sheet (`color-mix(in srgb, var(--green) 55%/32%, var(--sheet))`). Pencil grey is used for the last category, and bare sheet stands for profit. No new hues.

## Typography

**Display Font:** Zilla Slab (Georgia fallback), weights 500 to 700
**Body Font:** Karla (system-ui fallback)
**Label/Mono Font:** Overpass Mono (ui-monospace, Menlo fallback)

**Character:** A printed slab for the book's own heads, a plain humanist sans for the bookkeeper's sentences, and a mono with tabular figures so every column foots by eye.

### Hierarchy
- **Display** (700, clamp 34–54px, 1): the book title, in printed green.
- **Headline** (700, 25px, 1.15): section heads such as The ledger, Adjusting entries and Reconciliation.
- **Title** (700, 18px): panel heads. Ledger column heads use 700 at 15px/1.2, with the PMS name below in 11.5px mono pencil.
- **Memorandum** (Karla 500, clamp 18–22px, 1.45, max 58ch): the one-sentence period summary, with key figures in 700.
- **Body** (Karla 400, 16px, 1.55): captions run 14–15px at faded ink with a max of 64–84ch.
- **Figure** (Overpass Mono, 14.5px, tabular-nums): every amount, ratio and count. Change figures sit below at 12px in pencil.
- **Label** (mono 600, 11.5px, 0.06em, uppercase): picker labels, the synthetic tag and reconciliation column heads. Ledger category rows use mono 700 at 12px with 0.08em.

### Named Rules
**The Figures-in-Mono Rule.** Any number a reader might add up is set in Overpass Mono with tabular figures. Prose numbers inside sentences stay in Karla.

**The Parenthesis Rule.** Negatives render as `($1,234)` or `(3.1%)`, never with a minus sign. Change figures are the exception: they are deltas and use `+` / `−`, with `pts` for ratio changes.

## Layout

A single 1240px column (page padding `28px 24px 56px`). The head is a two-column grid (title and memo line left, pickers right) closed by a 3px double green rule. The memorandum follows as a 120px label column plus the sentence. Sections are spaced 34px apart. Panels pair in `1.55fr / 1fr` grids, or `1fr / 1fr` for entries and reconciliation, with a 28px gutter, and collapse to one column at 980px.

The ledger is a real table in a horizontally scrollable sheet (min-width 820px) with a sticky first column. Below 700px the page padding tightens to `18px 16px 44px`, the pickers go full width, and the ledger drops to the row label plus the selected column only. A phone-only note explains that, and the reconciliation hides its middle column and folds that figure under the ledger figure.

## Elevation & Depth

None. The system is flat paper: sheets and panels sit on the page as a lighter tone with a 1.5px printed-green frame. Hover and selection are carried by an 8% green wash, not by lift.

### Named Rules
**The Flat Paper Rule.** No box-shadows, no blur, no gradients beyond the select's drawn chevron. Separation comes from tone, frame and rule weight.

## Shapes

Square corners everywhere (0px). Line weight carries the hierarchy:
- 1px feint rules between rows and columns.
- 1px margin rule at the row-label margin.
- 2px rules under column heads, and 2px margin rule to set off the Group column.
- 1.5px frames on sheets, panels, selects, tags and tooltips.
- 3px double rules under footings (operating profit, totals) and at the head and footer.

Bars are plain rectangles: outlined for production, filled for collections, and 9px bars for the sub-ledger.

## Components

### Pickers (selects)
Square sheet-coloured field with a 1.5px green frame, Karla 600 at 15px, a 42px minimum height, and a chevron drawn in green from two gradient triangles. Labels sit above in uppercase mono pencil. Focus uses the global 2px green outline offset by 2px.

### Synthetic tag
Inline 1.5px green-framed box with uppercase mono label type, set beside the title. Labelling the data synthetic is a product requirement.

### Ledger sheet (signature)
Column heads are green slab with the PMS name in mono pencil beneath, keyboard-focusable, and selecting one carries that office through the page. The selected office's column gets the wash. The Group column is ruled off by the 2px margin rule. Category rows (Revenue / Costs / Patients & capacity) use uppercase mono green over a margin rule. Sub-lines are indented 26px and set in faded ink. The footing row (operating profit) is 600/700 weight over a 3px double ink rule. Each cell shows the figure with its change against the prior period below it.

### Panels
A sheet with a 1.5px green frame and `14px 16px 12px` padding, holding a slab title, a faded-ink caption and the content. Chart keys are 12px mono swatches. Charts are flat SVG on the sheet: feint gridlines, mono pencil axes and a 1.5px ink baseline. Tooltips are a framed sheet in 12.5px mono, and the hovered month gets the wash.

### Disbursement strip
A 34px ink-framed bar split into flex segments with sheet-coloured dividers. The table beneath has swatches, amount and share columns, and the profit row is closed by a double rule.

### Adjusting entries
A list under a 2px green rule. Each entry is a `64px / 92px / 1fr` row: a green mono "Adj. n" number, a 17px mono count and the explanation in faded ink.

### Reconciliation
A mono figure table with green uppercase mono heads over a 2px green rule and a total row over a double rule. A zero difference shows an inline SVG auditor's tick (14×12, 1.6px green stroke, round caps) and `$0.00` in green. Any other difference is red, in parentheses.

## Do's and Don'ts

### Do:
- **Do** set every summable figure in Overpass Mono with tabular numerals, and every negative in red ink with parentheses.
- **Do** close every footing or total with a 3px double rule, and frame sheets and panels with a 1.5px printed-green line.
- **Do** mark the selected office and hovered month with the 8% green wash.
- **Do** derive extra fills from printed green mixed into the sheet before reaching for any new hue.
- **Do** draw any check or status mark as inline SVG in the ink colours.

### Don't:
- **Don't** add shadows, rounded corners or gradients; the paper is flat.
- **Don't** use red for anything but a loss or a variance, or let colour alone carry a status.
- **Don't** introduce a second accent hue or borrow any sibling project's palette.
- **Don't** set figures in Karla or Zilla Slab inside tables.
