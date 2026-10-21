# Tableau Dashboard Blueprint

The dashboard answers one question: should the first gate stay at level 30? It shows the Phase 4 results as exported by `notebooks/04_statistical_testing.ipynb` (section 4.7) and recalculates nothing.

---

# Dashboard Overview

| Field | Value |
|--------|-------|
| Dashboard Name | Cookie Cats: Should the First Gate Stay at Level 30? |
| Business Question | Does moving the first gate from level 30 to level 40 change player retention? |
| Audience | Product team (decision-makers); game design and monetisation teams |
| Platform | Tableau Public |
| Last Updated | 2026-10-21 |

---

# Data Sources

| File | Contents | Rows |
|------|----------|------|
| `tableau/data/retention_by_version.csv` | Players, retained players and retention rate by version, for 1-day and 7-day retention | 4 |
| `tableau/data/retention_differences.csv` | Difference (gate_40 − gate_30), 95% interval and p-value for the main results, the bootstrap interval and the sensitivity checks | 6 |
| `tableau/data/rounds_distribution.csv` | Share of each version's players by game rounds, in 5-round bins from 0 to 250, plus the share above 250 | 102 |

Only aggregated results are published. The player-level data is not, because the dataset's licence is listed as Unknown.

---

# Primary KPIs

| KPI | Definition | Source |
|-----|------------|--------|
| 7-day retention, gate_30 | Share of players assigned to gate_30 who came back to play 7 days after installing | `retention_by_version.csv` |
| 7-day retention, gate_40 | The same for gate_40 | `retention_by_version.csv` |
| 7-day difference | gate_40 − gate_30 in percentage points, with its 95% interval | `retention_differences.csv`, main analysis |
| Decision | Keep the gate at level 30 (the 95% interval lies entirely below zero) | Decision Rules in `PROJECT_INFO.md` |

---

# Planned Worksheets

| Worksheet | Chart | Question answered |
|-----------|-------|-------------------|
| KPI cards | Four text cards | What did each version record, and what is the decision? |
| Retention difference | Dot for each difference with a horizontal line for its 95% interval and a vertical reference line at zero; rows for 7-day and 1-day retention | Is each difference clearly below zero, or could it be zero? |
| Retention by version | Grouped bars, one group per retention measure, one bar per version | What were the retention rates? |
| Game rounds | Step lines of the share of players by 5-round bin, one line per version, with the share above 250 rounds as a note | Did the versions differ in how much they played? |
| Robustness | Same dot-and-interval chart for the 7-day difference under the main analysis, the bootstrap interval and the three sensitivity checks | Does the 7-day result depend on the method or on unusual players? |

---

# Layout

Fixed canvas, 1600 × 900, the same as the Project 8 dashboards.

```text
+--------------------------------------------------------------------------+
| Title band (navy): title and one-line subtitle                           |
+--------------+--------------+--------------+-----------------------------+
| KPI: 7-day   | KPI: 7-day   | KPI: 7-day   | KPI: Decision               |
| gate_30      | gate_40      | difference   |                             |
+--------------+--------------+--------------+-----------------------------+
| Retention difference (dots, 95% intervals,       | Insight and           |
| zero line)                                       | Recommendation (navy) |
+-------------------------+------------------------+                       |
| Retention by version    | Game rounds            |                       |
| (bars)                  | (step lines)           |                       |
+-------------------------+------------------------+-----------------------+
| Robustness: 7-day difference under each check (dots, 95% intervals)      |
+--------------------------------------------------------------------------+
| Footer: Cookie Cats A/B Test • Taofeek Salami • repository link          |
+--------------------------------------------------------------------------+
```

The Insight and Recommendation panel uses the text of the executive summary, shortened. It does not introduce new claims.

---

# Interactions

- Tooltips on every mark: exact values, interval and p-value where relevant.
- No filters: version is the only grouping in the data, and splitting players by game rounds is ruled out because rounds were recorded after assignment.

---

# Design Notes

The identity elements follow the house style of the Project 8 dashboard (Fintech Credit Risk Analysis), so the two read as the same author's work. The data colours are chosen for this project's data.

## Identity Elements

| Element | Setting |
|---------|---------|
| Canvas | Fixed, 1600 × 900 |
| Title band | Background navy `#1F3864`; title 18pt Tableau Bold, white `#FFFFFF`; subtitle 8pt Tableau Bold, blue-grey `#A9B4C2` |
| KPI cards | Background navy `#1F3864`, 1px navy border, 5px margin and padding; value 24pt Tableau Bold, white; label 8pt Tableau Light, `#A9B4C2` |
| Chart panels | Background `#F5F5F5`, 4px margin and padding; gridlines off; values labelled directly where an axis is hidden |
| Chart titles | 10pt Tableau Bold, `#262626` |
| Labels and body text | 8pt Tableau Light, `#262626` |
| Insight and Recommendation panel | Background navy `#1F3864`; headings 12pt Tableau Bold, gold `#D4AF37`; bullets 8pt Tableau Light, `#A9B4C2` |
| Footer | Background `#DAE3F3`; 8pt Tableau Light, navy `#1F3864`: "Cookie Cats A/B Test • Taofeek Salami" and the repository link |
| Fonts | Tableau Light and Tableau Bold only |

## Data Colours

| Use | Colour | Reason |
|-----|--------|--------|
| gate_30 | `#3a5ea8` (lifted navy) | Brand navy family, light enough to read as a chart mark |
| gate_40 | `#b8892a` (deepened gold) | Brand gold family, dark enough for 3:1 contrast on a light background |
| Differences and intervals | `#262626` | Neutral: a difference belongs to neither version |
| Zero reference line | `#999999` | Visible but secondary to the marks |

The pair passes checks for lightness, separation under colour-vision deficiency and contrast. The brand navy `#1F3864` and gold `#C9A84C` failed as chart marks (the navy reads as near-black, the gold has 2.2:1 contrast on white), so they are kept for identity elements only.

Red `#C00000` is not used. In the Project 8 dashboard it marks critical risk, and the two versions here are neither good nor bad.

## Accessibility

- Every mark is labelled with its version, so identity never relies on colour alone.
- Bar charts start at zero; difference charts keep zero visible.
- Text is never drawn in a version colour.

---

# Validation Checklist

- [ ] Every value on the dashboard matches the Phase 4 results
- [ ] Difference charts show gate_40 − gate_30, with the zero line visible
- [ ] Tooltips reviewed
- [ ] Titles, notes and the assignment caveat included
- [ ] Dashboard answers the business question at a glance
- [ ] Published to Tableau Public and linked from the README

---

# Business Commentary

7-day retention was 0.8 percentage points lower for players assigned to the level-40 gate (95% interval 0.3 to 1.3 points lower), so under the Decision Rules the gate stays at level 30. 1-day retention was also lower but not statistically significant, and game rounds were very similar. The causal reading depends on random assignment, which cannot be confirmed from the data.