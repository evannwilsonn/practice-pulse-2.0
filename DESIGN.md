---
name: Practice Pulse 2.0
description: An owner's ledger book for an 18-office dental group in three regions, footed, adjusted, audited and reconciled to the cent.
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
  caption-head:
    fontFamily: "Zilla Slab, Georgia, serif"
    fontSize: "16px"
    fontWeight: 700
  column-head:
    fontFamily: "Zilla Slab, Georgia, serif"
    fontSize: "15px"
    fontWeight: 700
    lineHeight: 1.2
  tab:
    fontFamily: "Zilla Slab, Georgia, serif"
    fontSize: "14px"
    fontWeight: 700
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
  note-body:
    fontFamily: "Karla, system-ui, sans-serif"
    fontSize: "15.5px"
    fontWeight: 400
  caption:
    fontFamily: "Karla, system-ui, sans-serif"
    fontSize: "14.5px"
    fontWeight: 400
  footer:
    fontFamily: "Karla, system-ui, sans-serif"
    fontSize: "13.5px"
    fontWeight: 400
    lineHeight: 1.7
  figure:
    fontFamily: "Overpass Mono, ui-monospace, Menlo, monospace"
    fontSize: "14.5px"
    fontWeight: 400
    fontFeature: "tnum"
  figure-compact:
    fontFamily: "Overpass Mono, ui-monospace, Menlo, monospace"
    fontSize: "13.5px"
    fontWeight: 400
    fontFeature: "tnum"
  figure-count:
    fontFamily: "Overpass Mono, ui-monospace, Menlo, monospace"
    fontSize: "17px"
    fontWeight: 600
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
  mono-small:
    fontFamily: "Overpass Mono, ui-monospace, Menlo, monospace"
    fontSize: "12.5px"
    fontWeight: 500
  axis:
    fontFamily: "Overpass Mono, ui-monospace, Menlo, monospace"
    fontSize: "11px"
    fontWeight: 500
  pen-footnote:
    fontFamily: "Nanum Pen Script, Segoe Print, Bradley Hand, cursive"
    fontSize: "22px"
    fontWeight: 400
    lineHeight: 0
  pen-footnote-memo:
    fontFamily: "Nanum Pen Script, Segoe Print, Bradley Hand, cursive"
    fontSize: "26px"
    fontWeight: 400
    lineHeight: 0
  pen-note-letter:
    fontFamily: "Nanum Pen Script, Segoe Print, Bradley Hand, cursive"
    fontSize: "32px"
    fontWeight: 400
    lineHeight: 0.7
rounded:
  none: "0px"
spacing:
  cell-y: "8px"
  cell-x: "14px"
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
  index-tab:
    backgroundColor: "{colors.ledger-paper}"
    textColor: "{colors.printed-green}"
    typography: "{typography.tab}"
    padding: "7px 22px 6px"
    height: "36px"
  index-tab-selected:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.printed-green}"
    padding: "7px 22px 8px"
  ledger-sheet:
    backgroundColor: "{colors.sheet}"
    rounded: "{rounded.none}"
  ledger-column-head:
    textColor: "{colors.printed-green}"
    typography: "{typography.column-head}"
    padding: "12px 14px 8px"
  ledger-cell:
    textColor: "{colors.ink}"
    typography: "{typography.figure}"
    padding: "8px 14px"
  trial-balance-head:
    textColor: "{colors.printed-green}"
    typography: "{typography.label}"
    padding: "12px 22px 8px 6px"
  trial-balance-cell:
    textColor: "{colors.ink}"
    padding: "8px 22px 8px 6px"
  footnote-letter:
    textColor: "{colors.red-ink}"
    typography: "{typography.pen-footnote}"
  panel:
    backgroundColor: "{colors.sheet}"
    rounded: "{rounded.none}"
    padding: "{spacing.panel}"
---

# Design System: Practice Pulse 2.0

## Overview

**Creative North Star: "The Owner's Ledger Book"**

The page is a columnar accounting pad, not an admin dashboard. Pale ledger-green paper carries framed sheets of feint rules; heads are printed in green slab type, figures are written in black mono ink, deductions and losses go inside parentheses, and footings get double rules. Index tabs are cut into the top edge of the ledger sheet. Over the printed book sits one human hand: the auditor's red pencil, which circles exception figures and letters them to notes. The vocabulary is bookkeeping throughout: memorandum, journal, sub-ledger, trial balance, adjusting entries, reconciliation, notes to the accounts, an auditor's tick.

Density is a ledger's density: 18 offices across three regions, many figures, tight rows, nothing ornamental. Depth is paper on paper, framed by a 1.5px printed-green line, never lifted. Dark mode is the same book at night: green-black paper, soft green print, coral red ink. It is a distinct world from the rest of the portfolio, and it must never slide toward a generic SaaS admin look.

**Key Characteristics:**
- Ledger-green paper, green printed heads, black ink figures, red ink for losses and the auditor's hand.
- Four faces with fixed jobs: Zilla Slab heads, Karla prose, Overpass Mono figures, Nanum Pen Script for the auditor's letters only.
- Square 1.5px frames, feint 1px rules, 3px double rules under footings and totals.
- Flat everywhere; the only curve is the hand-drawn pencil ellipse.
- Every mark is labelled; the data is labelled synthetic at the head and in the notes.

## Colors

A near-monochrome green book with one red ink, mirrored for dark.

### Primary
- **Printed Green** (printed-green; night-green in dark): headings, column heads, tabs, sheet and panel frames, double rules under the head and footer, the selected-period collections line, filled collections bars, note numbers, the auditor's tick, focus ring.
- **Soft Print Green** (printed-green-soft; night-green-soft): a second green for adjacent fills, such as new-patient bars and the supplies segment.

### Secondary
- **Red Ink** (red-ink; coral-ink in dark): losses, reconciliation differences and the auditor's hand (circled exception figures, pencil footnote letters, exception letters and figures). In the journal it fills the collections bar for a month at a loss.

### Neutral
- **Ledger Paper** (ledger-paper; night-paper): the page ground and the face of unselected tabs.
- **Sheet** (sheet; night-sheet): ledger and trial-balance sheets, the selected tab, panels, selects, tooltips, sticky row labels.
- **Feint Rule** (feint-rule; night-feint-rule): row and column rules, chart gridlines, the running line's baseline.
- **Margin Rule** (margin-rule; night-margin-rule): heavier structural rules: the row-label margin, the Group column rule-off, category and region underlines, the memorandum and running-line underlines.
- **Ink / Faded Ink / Pencil** (ink, ink-faded, ink-pencil and night equivalents): figures and prose; sub-lines, captions and note text; change figures, axis labels, PMS names, tab counts, the dashed full-history line and picker labels.
- **Wash** (`rgba(44,90,55,.08)` light, `rgba(143,199,154,.08)` dark): marks the selected office column, the selected trial-balance row and the hovered journal month. Sticky cells use the opaque equivalent `color-mix(in srgb, var(--green) 8%, var(--sheet))`.

### Named Rules
**The Red Ink Rule.** Red means a loss, a variance, or the auditor's mark, nothing else. A red negative always also carries parentheses, and a circled figure always carries a letter that points to a row in the exceptions schedule, so colour never carries the meaning alone.

**The Deduction Rule.** Deductions such as write-offs and discounts sit in parentheses in ordinary ink. Parentheses say "subtract"; only red says "loss".

**The Green Tint Rule.** Additional fills are mixed from printed green into the sheet or paper (`color-mix(in srgb, var(--green) 55%/32%, var(--sheet))` for categories, 7% into the paper for unselected tabs). Pencil grey is used for the last category, and bare sheet stands for profit. No new hues.

## Typography

**Display Font:** Zilla Slab (Georgia fallback), weights 500 to 700
**Body Font:** Karla (system-ui fallback)
**Label/Mono Font:** Overpass Mono (ui-monospace, Menlo fallback)
**Hand Font:** Nanum Pen Script (Segoe Print, Bradley Hand, cursive fallback), 400, red ink only

**Character:** A printed slab for the book's own heads, a plain humanist sans for the bookkeeper's sentences, a mono with tabular figures so every column foots by eye, and one pencil hand for the auditor.

### Hierarchy
- **Display** (Slab 700, clamp 34–54px, 1): the book title, in printed green.
- **Headline** (Slab 700, 25px, 1.15): section heads such as The ledger, Trial balance by office, Auditor's exceptions, Reconciliation.
- **Title** (Slab 700, 18px): panel heads. Reconciliation table captions use 16px; ledger column heads and the Memorandum label use 15px (column heads at 1.2); tabs use 14px, 13px on phones.
- **Memorandum** (Karla 500, clamp 18–22px, 1.45, max 62ch): the one-sentence period summary, with key figures in 700.
- **Body** (Karla 400, 16px, 1.55). ledger and trial-balance row labels and the pickers 15px; section captions and notes to the accounts 14.5px; panel captions and sheet notes 14px; the footer 13.5px at 1.7. Inline links and office-name buttons are Karla 600 at 15px.
- **Figure** (Overpass Mono 400, 14.5px, tabular-nums): ledger figures. Trial balance and disbursement figures use 14px, reconciliation figures 13.5px (12.5px on phones), adjusting-entry counts 600 at 17px. Change figures sit below at 12px in pencil.
- **Label** (Mono 600, 11.5px, 0.06em, uppercase): picker labels and the synthetic tag. Trial-balance heads are mono 700 at 11.5px with 0.02em; reconciliation heads mono 700 at 12px with 0.06em; ledger category and region rows mono 700 at 12px with 0.08em.
- **Small mono** (Mono 500): PMS names under heads and the running-line caption at 11.5px; source lines and row hints at 12px; chart keys and tooltips at 12.5px; note numbers and adjusting-entry numbers at 600, 13px and 12.5px; code at 13px; tab counts and axis labels at 11px.
- **Pen** (Nanum Pen Script 400, red): footnote letters at 22px with line-height 0, raised to superscript; 26px beside the memorandum. The exceptions schedule uses plain red mono letters, not the pen.

### Named Rules
**The Figures-in-Mono Rule.** Any number a reader might add up is set in Overpass Mono with tabular figures. Prose numbers inside sentences stay in Karla.

**The Parenthesis Rule.** Negatives and deductions render as `($1,234)` or `(3.1%)`, never with a minus sign. Change figures are the exception: they are deltas and use `+` / `−`, with `pts` for ratio changes.

**The One Hand Rule.** Nanum Pen Script is the auditor's pencil: single footnote letters in red ink beside figures and the memorandum, nothing else. Never set words, figures or headings in it.

## Layout

A single 1240px column (page padding `28px 24px 56px`). The head is a two-column grid (title and sub-line left, pickers right), followed by the running line between a 3px double green rule and a 1px margin rule. The memorandum is a 120px label column plus the sentence. Sections are 34px apart, each with a slab head and a faded caption on one baseline. Panels pair in `1.55fr / 1fr` grids with a 28px gutter; adjusting entries and reconciliation pair `1fr / 1.25fr` and stack below 1420px. All pairs stack at 980px, where notes to the accounts drop from two columns (36px gap) to one.

The ledger and trial balance are real tables in horizontally scrollable sheets (min-width 760px and 1000px) with sticky first columns. The ledger shows the three regions plus Group, with the picked office prepended when one is chosen. The trial balance groups offices under region rows, each closed by a subtotal, and ends with a group total. Below 700px the page padding tightens to `18px 16px 44px`, pickers go full width, the four tabs become an equal grid without counts, the ledger shows the row label plus the picked column only (a phone-only note says so), and the reconciliation folds its middle column under the ledger figure.

## Elevation & Depth

None. The system is flat paper: sheets and panels sit on the page as a lighter tone with a 1.5px printed-green frame. Tabs join their sheet by tone, not lift: the selected tab takes the sheet colour and overlaps the frame by 1.5px. Selection is carried by the 8% green wash.

### Named Rules
**The Flat Paper Rule.** No box-shadows, no blur, no gradients beyond the select's drawn chevron. Separation comes from tone, frame and rule weight.

## Shapes

Square corners on every frame, field, tab and bar (0px). Line weight carries the hierarchy:
- 1px feint rules between rows and columns.
- 1px margin rule at the row-label margin and under category and region rows.
- 1px faded-ink rule above subtotals.
- 2px green rules under column heads and atop lists; 2px margin rule to set off the Group column.
- 1.5px frames on sheets, tabs, panels, selects, tags and tooltips.
- 3px double rules under footings and totals, and at the head and footer.

Index tabs are trapezoids (`clip-path` inset 9px each side at the top, 6px on phones). The one curve in the system is the red-pencil ellipse: a 1.6px red ring at 0.9 opacity with an irregular radius picked from four asymmetric sets and a rotation varied per letter (−5° to 4°). Bars are plain rectangles: outlined for production, filled for collections, 9px for the sub-ledger.

## Components

### Pickers (selects)
Square sheet-coloured field with a 1.5px green frame, Karla 600 at 15px, a 42px minimum height, and a chevron drawn in green from two gradient triangles. The office picker groups offices by region. Labels sit above in uppercase mono pencil. Focus uses the global 2px green outline offset by 2px.

### Synthetic tag
Inline 1.5px green-framed box with uppercase mono label type, set beside the title. Labelling the data synthetic is a product requirement.

### Running line
A 58px collections line under the head across the full width: the whole history as a dashed pencil line (1.2px, `2 4`), the selected period traced over it as a solid 2.4px green line, a 1px green tick at the period start and a 3.5px green dot at its end, over a feint baseline. Caption in 11.5px mono pencil: first month, what the line is, last month.

### Index tabs
A `tablist` of trapezoid dividers (Group plus one per region) cut into the ledger sheet's top edge, each with a mono count of offices. Unselected tabs are framed in green over paper tinted 7% green; the selected tab takes the sheet colour and 2px more bottom padding so it reads as continuous with the sheet. Arrow keys, Home and End move the selection; focus is an inset outline.

### Ledger sheet (signature)
Column heads are green slab with the office count or PMS name in mono pencil beneath. The picked column gets the wash and the Group column is ruled off by the 2px margin rule. Category rows (Revenue / Costs / Patients & capacity) use uppercase mono green over a margin rule. Sub-lines are indented 26px in faded ink. Revenue runs gross to net: gross production, less write-offs and discounts in parentheses, then net production over a faded-ink rule. The footing row (operating profit) is 600/700 weight over a 3px double ink rule. Each cell shows its change against the prior period below it.

### Red-pencil marks
An exception figure in the picked office's column is circled in red pencil with its letter set at its upper right; in region and Group columns the letters follow the figure instead. Letters are assigned a, b, c in order of dollar effect and carry a visually hidden "see note" for screen readers.

### Trial balance
One row per office, Karla 600 office names underlined in feint rule (links into the ledger) with the PMS and type in mono pencil. Uppercase mono heads are sort buttons, with a drawn 9×10 arrow and `aria-sort` on the sorted column; sorting happens within each region. Region rows use the category style; subtotals are 600 over a faded-ink rule, and the group total is 700 over a 3px double rule. Exceptions are circled in place. The selected office's row takes the wash.

### Auditor's exceptions
A schedule on a framed sheet, not prose. Columns: note letter (600 15px mono, red, plain, not pen), office (underlined Karla 600 button that opens the office, with region and PMS beneath in 11.5px mono), line (Karla in faded ink with the source system beneath), figure (600 mono, red), peer median (mono ink) and effect (600 mono dollars with a short plain-English gloss such as "not collected" beneath). Rows run largest dollar effect first. On phones the head is hidden and each row becomes a `28px / 1fr / auto` grid: letter, office over line with "figure against peer median", and the effect on the right. An empty scope gets a single faded sentence saying every office is inside the thresholds.

### Panels
A sheet with a 1.5px green frame and `14px 16px 12px` padding, holding a slab title, a faded-ink caption and the content. Chart keys are 12px swatches in 12.5px mono. Charts are flat SVG on the sheet: feint gridlines, mono pencil axes, a 1.5px ink baseline, outlined gross production with a 2px ink net tick. Tooltips are a framed sheet in 12.5px mono, and the hovered month gets the wash.

### Disbursement strip
A 34px ink-framed bar split into flex segments with sheet-coloured dividers. The table beneath has swatches, amount and share columns, and the profit row is closed by a double rule.

### Adjusting entries
A list under a 2px green rule. Each entry is a `64px / 92px / 1fr` row: a green mono "Adj. n" number, a 17px mono count and the explanation in faded ink.

### Reconciliation
Two stacked mono figure tables, gross production then write-offs and discounts, each with a 16px slab caption, green uppercase mono heads over a 2px green rule and a total row over a double rule. A zero difference shows an inline SVG auditor's tick (14×12, 1.6px green stroke, round caps) and `$0.00` in green. Any other difference is red, in parentheses.

### Notes to the accounts
A numbered list in two balanced columns under a 2px green rule. Each note is a `28px / 1fr` row: a green mono number, then a bold ink term and faded definition at 14.5px. The auditor's thresholds live here.

## Do's and Don'ts

### Do:
- **Do** set every summable figure in Overpass Mono with tabular numerals, and every negative or deduction in parentheses.
- **Do** close every footing and final total with a 3px double rule (subtotals take a single faded-ink rule above), and frame sheets, tabs and panels with a 1.5px printed-green line.
- **Do** mark the picked office, its trial-balance row and the hovered month with the 8% green wash.
- **Do** derive extra fills from printed green mixed into the sheet or paper before reaching for any new hue.
- **Do** pair every red-pencil circle with a pen letter that resolves to a row in the exceptions schedule.
- **Do** draw any check, arrow or status mark as inline SVG in the ink colours.

### Don't:
- **Don't** add shadows, gradients or rounded corners to frames, fields, tabs or bars; the pencil ellipse is the only curve.
- **Don't** use red for anything but a loss, a variance or the auditor's mark, and don't colour deductions red.
- **Don't** use Nanum Pen Script for anything but single red footnote and note letters.
- **Don't** introduce a second accent hue or borrow any sibling project's palette.
- **Don't** set figures in Karla or Zilla Slab inside tables.
