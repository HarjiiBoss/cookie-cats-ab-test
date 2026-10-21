# Phase 3 — Analytical Method Selection

This document records the methods chosen for Phase 4 and why. The business question, metrics and decision rules are in [PROJECT_INFO.md](../PROJECT_INFO.md); the descriptive results that raised these questions are in [phase_02_business_analysis.md](phase_02_business_analysis.md).

---

# Phase Status

| Field | Value |
|--------|-------|
| Status | Complete |
| Started | 2026-10-20 |
| Completed | 2026-10-21 |
| Owner | Taofeek Salami |
| Branch | `phase-3-method-selection` |

---

# Timing of These Choices

The methods were chosen on 2026-10-21, after the Phase 2 descriptive gaps were known (−0.82 percentage points for 7-day retention). Each choice below is the standard method for its type of data rather than one selected for this result, and at this sample size the reasonable alternatives for the primary metric give practically the same interval. The decision rule itself (α, δ and the reading of the interval) was fixed in Phase 0 and is not changed here.

---

# Selected Methods

| Question | Method | Role |
|----------|--------|------|
| Does 7-day retention differ between versions? | Two-sided two-proportion z-test with a 95% Wald confidence interval for Δ | Primary. The interval decides the outcome under Decision Rules |
| Does 1-day retention differ between versions? | Same method, under fixed-sequence testing | Secondary. Supports interpretation; cannot change the decision |
| Do game rounds differ between versions? | Two-sided Mann–Whitney U test, with the probability of superiority as effect size | Guardrail, exploratory. Outside the error-rate control |
| How large a 7-day retention difference could this sample detect? | Minimum detectable difference at α = 0.05 (two-sided) and 90% power | Context for reading the primary result |

---

## 7-Day Retention (primary)

Two independent groups, one yes/no outcome per player, and large counts (at least 8,279 retained and 36,198 not retained in each version), so the normal approximation for each proportion is accurate.

- **Estimate:** Δ = 7-day retention for gate_40 minus 7-day retention for gate_30.
- **Interval:** 95% Wald interval for Δ, using each version's own rate for the standard error (unpooled). `statsmodels` `confint_proportions_2indep(method="wald")`.
- **Test:** two-sided z-test, which uses the pooled rate for the standard error, as the null hypothesis assumes equal rates. `statsmodels` `proportions_ztest`.
- **Decision:** read from the interval, as Decision Rules state (L > 0, U < 0, or the interval includes 0). The p-value is reported alongside. If the pooled test and the unpooled interval ever disagree near the boundary, the interval decides.

| Alternative | Reason not chosen |
|-------------|-------------------|
| Chi-square test on the 2×2 table | Same p-value as the z-test (χ² = z²) but no interval for Δ |
| Newcombe (Wilson-score) interval | Better for small samples or rates near 0% or 100%; practically identical here |
| Bootstrap interval | Fewer assumptions but slower and harder to explain; used as the Phase 4 robustness check instead |
| Fisher's exact test | Designed for small counts |
| Logistic regression | No covariates to adjust for, so it reduces to the z-test with extra complexity |

---

## 1-Day Retention (secondary)

Same z-test and Wald interval as the primary metric. Running two tests at α = 0.05 would raise the chance of at least one false positive to about 9.75%. Fixed-sequence testing keeps that combined rate at 5% without changing the primary metric's α:

1. 7-day retention is tested first at α = 0.05.
2. Only if its interval excludes zero is 1-day retention tested at α = 0.05 and described as statistically significant or not.
3. If the 7-day interval includes zero, the 1-day difference is reported with its interval as supporting information and is not labelled significant, whatever its p-value.

Bonferroni and Holm corrections were not used because both could lower the primary metric's α below the 0.05 fixed in Decision Rules.

---

## Game Rounds (guardrail, exploratory)

Game rounds are heavily right-skewed, include one value of 49,854, and have many tied values. The Mann–Whitney U test uses ranks, so the extreme value counts only as the highest rank, and it handles ties with a correction. It tests whether players in one version tend to play more rounds than players in the other; it is a test of medians only when both distributions have the same shape, so it is not described as one.

- **Test:** `scipy.stats.mannwhitneyu(..., alternative="two-sided", method="asymptotic")`.
- **Effect size:** probability of superiority, the chance that a randomly chosen gate_40 player played more rounds than a randomly chosen gate_30 player, with ties counted as half (U divided by the number of player pairs). 50% means no tendency either way.
- **Also reported:** medians and quartiles, and means with and without the flagged extreme player, without a test.
- **Label:** exploratory. Under Decision Rules the result does not block the decision and is outside the error-rate control.

| Alternative | Reason not chosen |
|-------------|-------------------|
| Welch t-test on means | One value moves the gate_30 mean by about 1.1 rounds and inflates the variance, so the result would be fragile |
| Bootstrap interval for the difference in medians | Rounds are whole numbers with many ties, so the median moves in jumps and the interval is hard to interpret |
| t-test on log(rounds + 1) | Answers a question on a multiplicative scale that is hard to explain to stakeholders |

---

## Minimum Detectable Difference

MDD = (z₁₋α/₂ + z₁₋β) × √[ p(1 − p) × (1/n₃₀ + 1/n₄₀) ]

| Input | Value |
|-------|-------|
| α | 0.05, two-sided (z = 1.960) |
| Power | 90% (z = 1.282) |
| Baseline rate p | gate_30 7-day retention, 19.02% |
| Group sizes | 44,700 and 45,489 |

The MDD uses the design inputs only, never the observed difference. Power calculated from the observed difference ("observed power") is fully determined by the p-value and adds no information, so it is not reported. The MDD is reported separately from the minimum effect of interest (δ = 0): the MDD describes what this sample could detect; δ describes what is worth acting on.

---

# Assumptions of the Methods

| Assumption | Why it matters | Status |
|------------|----------------|--------|
| Each player is one independent observation | All four methods assume independent outcomes | One row per player and no player in both versions (Phase 1). Whether players influenced each other cannot be checked from the data |
| Counts are large enough for the normal approximation | Needed for the z-test and Wald interval | Met: at least 8,279 retained and 36,198 not retained per version |
| Players were randomly assigned (A-002) | Needed to read any difference as caused by the gate | Untested. The sample ratio test (p = 0.0086) raised no alert but does not establish random assignment |
| The intended split was 50/50 (A-009) | Basis of the sample ratio test | Not testable |

---

# Validation Plan for Phase 4

- Check the z-test and Wald interval against a manual calculation from the counts.
- Bootstrap interval for Δ (7-day retention) as a robustness check, reported whatever its result.
- Rerun the primary and guardrail analyses excluding the flagged extreme player and the zero-round players, as the charter plans. Reported as sensitivity checks; they do not replace the main analysis.
- Report the sample ratio imbalance (50.44% gate_40, p = 0.0086) in the validity notes.

---

# Methods Considered and Not Used

- **Variance reduction using pre-experiment data (CUPED):** the data has no measurements from before assignment.
- **Splitting players by game rounds:** game rounds were recorded after assignment, so groups defined by them are no longer comparable between versions.
- **Bayesian analysis:** the Decision Rules are set as a frequentist confidence-interval rule; changing framework now would change a pre-set rule.

---

# Exit Checklist

- [x] A method selected for each remaining question
- [x] Each choice justified, with alternatives and reasons recorded
- [x] Assumptions of each method stated with their status
- [x] Multiple-comparison approach consistent with the Decision Rules
- [x] Validation plan defined for Phase 4
- [x] Timing of the choices relative to the Phase 2 results disclosed

---

# Phase Outcome

Phase 4 will test 7-day retention with a two-proportion z-test and decide from its 95% Wald interval, test 1-day retention under fixed-sequence testing, compare game rounds with an exploratory Mann–Whitney U test, and report the minimum detectable difference at 90% power. The methods are standard for each type of data and leave the Phase 0 decision rule unchanged.