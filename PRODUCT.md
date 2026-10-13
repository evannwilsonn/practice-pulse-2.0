# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Hiring managers first, arriving from Evan Wilson's resume or LinkedIn and giving the page about a minute. They need to see an end-to-end analytics pipeline that unifies messy exports from a multi-location dental group into one governed KPI dashboard. Analytics engineers second: they check definitions, the cleanup counts, the reconciliation and the ratios. Desktop and phone viewing matter about equally. (Confirmed for the whole portfolio on 2026-10-09.)

## Product Purpose

Practice Pulse 2.0 is a synthetic but realistic pipeline for an 18-office Florida dental group in three regions (Tampa Bay, Gulf Coast, Central Florida; each with three Open Dental, two Dentrix Ascend and one Dolphin orthodontic office) plus Sage Intacct, UKG, Henry Schein and Google Ads. Raw exports are loaded untouched, cleaned (three date formats, currency and accounting-style negatives, 30 spellings of office names, Dolphin office codes, 2,753 duplicate rows, 6,170 deleted procedures, 13,912 treatment-plan rows, 485,600 write-offs in three sign conventions), modelled into a star schema, tested (106 tests including production and write-off reconciliation to the cent) and served as one KPI table.

The dashboard answers the owners' questions:
- How much did each office and region produce, write off and collect?
- Which offices are running off their peers, and what does it cost?
- Which office is most profitable?
- Where does the money go?
- Where do new patients come from, and at what ad cost?

## Positioning

The one place the group's numbers agree: every office, every system, one definition per metric, reconciled on every run.

## Operating Context

The page is static, with inline data (dashboard/data.json) built from DuckDB, and is Snowflake-ready. It is also published as a Claude artifact. All data is synthetic, with no patient or company data, and the page must say so.

## Capabilities and Constraints

- Data per location and month, 2024-01 to 2026-09 (33 months × 18 locations): gross production, write-offs, net production, collections, patient visits, new patients, provider hours, payroll, supplies, lab fees, overhead, ad spend and operating profit.
- Procedure mix by location, month and category (9 categories), with procedure counts and production.
- Procedure rows by source system.
- Locations with name, region, metro, PMS and specialty.
- Ratios are recomputed from summed totals for the selected range.
- Collection rate is measured on net production over a period, because single months swing with payment lag.
- Exceptions compare each office with the median of same-specialty peers, computed in the page from data.json.
- Every number comes from data.json.

## Brand Commitments

Each portfolio project has its own visual world and its own new colour palette. It must be distinct from all of these:
- Reprise: cool white, ink, blue ramp, amber.
- Cloverfield: control-room black, Caltrans orange, green/amber/red.
- Cloverleaf: concrete grey, plum, lime.
- Switchyard: cream, rust, umber.
- Curbside: newsprint broadsheet, ink, taxi yellow.
- Clip Curator: graphite, film black, hot pink.
- Throughline: kraft, thermal white, stamp teal.
- Bellwether: drum paper, violet pen, event red.
- The earlier IBM Plex blue look.

It also must not read as a generic SaaS admin dashboard.

## Evidence on Hand

dashboard/data.json; README cleanup counts and tests. No users or testimonials.

## Product Principles

1. Lead with how the group did in the period, in a sentence.
2. Compare offices fairly: the same definition everywhere, ratios from totals, peers of the same type.
3. Show the cleanup and reconciliation as part of the story.
4. Every mark maps to real (synthetic) data and is labelled as synthetic.

## Accessibility & Inclusion

WCAG AA contrast in light and dark; status never carried by colour alone; works at phone width.
