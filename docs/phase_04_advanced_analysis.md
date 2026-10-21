# Phase 4 — Advanced Analytics & Modelling

This document records the statistical tests run in Phase 4 and their results. The methods and their justification are in [phase_03_method_selection.md](phase_03_method_selection.md); the Decision Rules are in [PROJECT_INFO.md](../PROJECT_INFO.md).

---

# Phase Status

| Field | Value |
|--------|-------|
| Status | Complete |
| Started | 2026-10-21 |
| Completed | 2026-10-21 |
| Owner | Taofeek Salami |
| Branch | `phase-4-advanced-analysis` |

---

# Work Done

All analyses are in [notebooks/04_statistical_testing.ipynb](../notebooks/04_statistical_testing.ipynb). Counts are read from `cookie_cats.clean_cookie_cats` and checked against the Phase 2 totals before testing.

| Section | Analysis | Method |
|---------|----------|--------|
| 4.1 | 7-day retention (primary) | Two-proportion z-test and 95% Wald interval, with a manual check of both |
| 4.2 | 1-day retention (secondary) | Same method, under fixed-sequence testing |
| 4.3 | Game rounds (guardrail, exploratory) | Mann–Whitney U and probability of superiority, with a manual check of U |
| 4.4 | Minimum detectable difference | α = 0.05 two-sided, 90% power, gate_30 baseline |
| 4.5 | Robustness check | Bootstrap 95% interval for the 7-day difference (10,000 resamples, seed 2026) |
| 4.6 | Sensitivity checks | 7-day test and game-round test excluding the extreme player, the zero-round players, or both |

---

# Decision

The 95% interval for the 7-day retention difference (gate_40 − gate_30) is −1.33 to −0.31 percentage points. It lies entirely below zero, so under the Decision Rules the outcome is to **keep the gate at level 30**.

---

# Results

## 7-Day Retention (primary)

| | gate_30 | gate_40 |
|---|---|---|
| Players | 44,700 | 45,489 |
| Retained at day 7 | 8,502 | 8,279 |
| 7-day retention | 19.02% | 18.20% |

Difference −0.82 percentage points (−4.31% relative), 95% interval −1.33 to −0.31 points, z = −3.16, p = 0.0016. Statistically significant at α = 0.05. In relative terms the interval runs from about −7.0% to −1.6% of gate_30's rate; at gate_40's group size it corresponds to roughly 140 to 600 fewer players retained at day 7.

## 1-Day Retention (secondary)

Tested at α = 0.05 because the 7-day interval excludes zero (fixed-sequence testing). 44.23% for gate_40 against 44.82% for gate_30: difference −0.59 percentage points, 95% interval −1.24 to +0.06, z = −1.78, p = 0.074. Not statistically significant: the data are consistent with no difference at day 1 and with a drop of up to about 1.2 points. The point estimate is in the same direction as the 7-day result.

## Game Rounds (guardrail, exploratory)

Medians 17 (gate_30) and 16 (gate_40). Probability of superiority 49.6%: a randomly chosen gate_40 player played more rounds than a randomly chosen gate_30 player 49.6% of the time, against 50% if neither version tended to play more. Mann–Whitney U p = 0.050. The data show at most a very small tendency for gate_40 players to play fewer rounds. Exploratory under Decision Rules, so it does not affect the decision.

## Minimum Detectable Difference

0.85 percentage points (4.45% relative to gate_30's 19.02%) at α = 0.05 two-sided and 90% power. The observed gap of 0.82 points is close to this value: a true gap of that size would be detected about 88% of the time, and gaps much smaller than 0.85 points would often be missed. Significant results near the detection limit tend to overstate the true effect, so the full interval is the better summary of the effect size than the point estimate.

## Robustness and Sensitivity

| Analysis | Players | 7-day difference (pp) | 95% interval (pp) | p (7-day) | Decision | Probability of superiority | p (rounds) |
|----------|---------|-----------------------|-------------------|-----------|----------|----------------------------|------------|
| All players (main analysis) | 90,189 | −0.820 | −1.328 to −0.312 | 0.0016 | Keep at level 30 | 0.4962 | 0.0502 |
| Excluding the extreme player | 90,188 | −0.818 | −1.326 to −0.310 | 0.0016 | Keep at level 30 | 0.4962 | 0.0509 |
| Excluding zero-round players | 86,195 | −0.812 | −1.341 to −0.284 | 0.0026 | Keep at level 30 | 0.4969 | 0.1163 |
| Excluding both | 86,194 | −0.810 | −1.339 to −0.282 | 0.0026 | Keep at level 30 | 0.4969 | 0.1177 |

Bootstrap 95% interval for the 7-day difference: −1.33 to −0.32 percentage points, within 0.004 points of the Wald interval.

The primary result and the decision do not depend on the extreme player or the zero-round players. The small game-round tendency is weaker when zero-round players are excluded (p rises from 0.050 to 0.116), so part of it is associated with gate_40's higher zero-round share (4.52% against 4.33%). The filtered groups are defined by game rounds, which were recorded after assignment, so these comparisons are sensitivity checks and do not replace the main analysis.

---

# Validity Notes

- **Random assignment (A-002).** Reading the 7-day difference as caused by the gate position depends on random assignment, which cannot be confirmed from the data. The sample ratio test raised no alert (p = 0.0086 against a 0.001 threshold) but the split, 50.44% gate_40, is unusual for a true 50/50 allocation at the conventional 0.05 level.
- **Retention definition (A-005).** The exact meaning of the retention flags is documentation-based.
- **Players who never met the gate.** The data has no level column, so every player is included (intent-to-treat). Any effect among players who reached level 30 is averaged over all players.
- **Effect size near the detection limit.** The point estimate (−0.82) is close to the minimum detectable difference (0.85), so the true effect may be nearer the lower end of the interval.

---

# What the Results Do Not Show

- **Revenue or purchases.** The data has no revenue column, so the effect on monetisation is unknown.
- **Why retention differs.** The data has no information on player behaviour at the gate.
- **Retention beyond day 7.** Only day 1 and day 7 are recorded.
- **Whether the difference is worth acting on commercially.** The decision rule uses δ = 0, so it establishes the direction of the effect, not that its size matters for the business. That depends on the value of a retained player, which is not in the data.

---

# Exit Checklist

- [x] Methods run as selected in Phase 3
- [x] Library results checked by manual calculation
- [x] Decision read from the 7-day interval under the Decision Rules
- [x] Secondary metric tested under fixed-sequence testing
- [x] Guardrail reported as exploratory
- [x] Minimum detectable difference reported
- [x] Robustness and sensitivity checks reported whatever their result
- [x] Validity notes and limitations documented

---

# Phase Outcome

Under the Decision Rules, the outcome is to keep the first gate at level 30: 7-day retention was 0.82 percentage points lower for gate_40 (95% interval −1.33 to −0.31, p = 0.0016), and the result held under the bootstrap interval and all three sensitivity checks. 1-day retention was also lower for gate_40 but not statistically significant, and game rounds were very similar between versions. The causal reading depends on random assignment, which cannot be confirmed from the data, and the size of the effect is close to the smallest this sample could reliably detect.