# Phase 2 — Business Analysis

This document records what was done and found during Phase 2. The business question, metrics and decision rules are in [PROJECT_INFO.md](../PROJECT_INFO.md). All results here are descriptive: they record what each version showed and do not test whether differences are larger than chance would produce, which is Phase 4.

---

# Phase Status

| Field | Value |
|--------|-------|
| Status | In Progress |
| Started | 2026-10-20 |
| Completed | 2026-10-20 |
| Owner | Taofeek Salami |
| Branch | `phase-2-business-analysis` |

---

# Work Done

| Step | Query | Notebook | Purpose |
|------|-------|----------|---------|
| Sample ratio test | 2.0 | `03_business_analysis.ipynb`, section 2.0 | Check the group split against 50/50 before comparing outcomes |
| Retention by version | 2.1, 2.2 | Section 2.1 | Retained players, rates and gaps for 1-day and 7-day retention |
| Game rounds by version | 2.3 | Section 2.3 | Distribution summary and chart for the guardrail metric |
| Retention patterns by version | 2.4 | Section 2.4 | Share retained on neither day, day 1 only, day 7 only, or both |

Queries are in [sql/02_business_analysis.sql](../sql/02_business_analysis.sql) and run against `cookie_cats.clean_cookie_cats`. The notebook runs the same queries and draws the charts. Counts were checked against the Phase 1 totals: retained players (40,153 at day 1, 16,781 at day 7), retention patterns, total game rounds (4,678,325) and zero-round players (3,994) all match.

---

# Sample Ratio Test

| Version | Players | Share | Expected under 50/50 |
|---------|---------|-------|----------------------|
| gate_30 | 44,700 | 49.56% | 45,094.5 |
| gate_40 | 45,489 | 50.44% | 45,094.5 |

Chi-square statistic 6.902, p = 0.0086. This is above the 0.001 alert threshold set in Decision Rules, so no sample ratio mismatch is flagged and the version comparisons go ahead. The p-value is below 0.05, so the imbalance is unusual for a true 50/50 split; it is carried into the Phase 4 validity notes. A pass does not show that assignment was random (A-002). The expected 50/50 split is itself an assumption (A-009).

---

# Findings

## Retention

| Metric | gate_30 | gate_40 | Gap (gate_40 − gate_30) | Relative gap |
|--------|---------|---------|-------------------------|--------------|
| 1-day retention (secondary) | 44.82% (20,034) | 44.23% (20,119) | −0.59 pp | −1.32% |
| 7-day retention (primary) | 19.02% (8,502) | 18.20% (8,279) | −0.82 pp | −4.31% |

Retention was lower for gate_40 at both points. At gate_40's group size, the 7-day gap corresponds to about 373 players.

## Retention Patterns

| Pattern | gate_30 | gate_40 |
|---------|---------|---------|
| Neither day | 51.10% | 51.87% |
| Day 1 only | 29.88% | 29.93% |
| Day 7 only | 4.09% | 3.90% |
| Both days | 14.94% | 14.30% |

The share retained at day 1 only is almost the same in both versions. The 7-day gap is in players retained at day 7 (both days and day 7 only), with gate_40 having a correspondingly higher share retained on neither day.

## Game Rounds (guardrail, exploratory)

| Measure | gate_30 | gate_40 |
|---------|---------|---------|
| Lower quartile | 5 | 5 |
| Median | 17 | 16 |
| Upper quartile | 50 | 52 |
| Mean | 52.46 | 51.30 |
| Mean without the flagged extreme player | 51.34 | 51.30 |
| Total rounds | 2,344,795 | 2,333,530 |
| Maximum | 49,854 | 2,640 |
| Zero rounds | 4.33% | 4.52% |
| Above 250 rounds | 4.2% | 4.1% |

The distributions are similar. The higher gate_30 total comes from the single player with 49,854 rounds; without that player the gate_30 total is 2,294,941, below gate_40's. On the chart, the largest visible separations are in the 0–4 rounds bin, where gate_40's share is higher, and between about 35 and 45 rounds, where gate_30's share is higher. These are visual readings and are not tested.

---

# Charts

| File | Shows |
|------|-------|
| `outputs/chart_retention_by_version.png` | 1-day and 7-day retention by version |
| `outputs/chart_gamerounds_by_version.png` | Share of each version's players by game rounds, 0 to 250 rounds in 5-round bins |

---

# Questions for Phase 3

- Which test and interval method suit the 7-day retention gap, the primary metric that decides the outcome under Decision Rules?
- Which multiple-comparison correction applies to 1-day retention as the secondary metric?
- Which method suits game rounds, given the skew and the single extreme value?
- What is the smallest 7-day retention difference this sample could reliably detect?

---

# Limitations

- The results are descriptive. No gap in this document has been tested, so none can yet be called statistically significant or attributed to the gate position.
- The split is 50.44% gate_40, which passed the sample ratio rule but is below the conventional 0.05 level (p = 0.0086).
- Game rounds were recorded after assignment and are described as an outcome only. They are not used to split players for the version comparison.
- The exact definition of the retention flags cannot be confirmed from the data (A-005), and the 14-day window for game rounds cannot be checked (A-006).
- The data has no level column, so players who never reached the gate are included in both versions (intent-to-treat). Any effect among players who met the gate is averaged across all players.

---

# Related Documentation

- [PROJECT_INFO.md](../PROJECT_INFO.md): business question, metrics and decision rules
- [assumption_register.md](assumption_register.md): A-002 (random assignment), A-005, A-006, A-009 (50/50 split)
- [phase_01_data_preparation.md](phase_01_data_preparation.md): clean table and Phase 1 totals used for the checks above

---

# Exit Checklist

- [x] Sample ratio test run before outcomes were compared by version
- [x] Primary and secondary metrics described by version
- [x] Guardrail metric described by version
- [x] Findings supported by query results, checked against Phase 1 totals
- [x] Charts saved to `outputs/`
- [x] SQL file and notebook run the same queries
- [x] Remaining questions identified for Phase 3
- [x] Limitations documented

---

# Phase Outcome

The group split passed the sample ratio rule (p = 0.0086, above the 0.001 threshold), so the version comparisons went ahead, with the imbalance noted for Phase 4. Retention was lower for gate_40 at both points: 7-day retention was 18.20% against 19.02% (−0.82 percentage points) and 1-day retention 44.23% against 44.82% (−0.59 percentage points). Game-round distributions are similar, with medians of 16 and 17. These gaps are descriptive. Whether they are larger than chance would produce, and so which decision rule applies, is settled in Phase 4 using the methods selected in Phase 3.