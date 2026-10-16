# Assumption Register

This register tracks every significant assumption in the project, from when it is made until it is validated, revised or retired. The Phase 0 snapshot is in [PROJECT_INFO.md](../PROJECT_INFO.md) → Initial Assumptions; this register is the version kept up to date. A status changes only after the check has actually been carried out.

| ID | Assumption | Category | Reason | Phase | Potential Impact | Validation Status | Owner |
|----|------------|----------|--------|-------|------------------|-------------------|-------|
| A-001 | Stakeholders are modelled on a typical mobile game studio | Business | The dataset is public and has no real client | 0 | Stakeholder needs may differ from a real studio's. Does not affect the statistical results | Not testable. Stated as a portfolio framing | Taofeek Salami |
| A-002 | Players were randomly assigned to gate_30 or gate_40 | Analytical | Needed for a causal reading of any difference | 0 | If false, a difference cannot be attributed to the gate | Untested. Indirect check only: sample ratio test in Phase 3 | Taofeek Salami |
| A-003 | Each row is one unique player | Data | Retention rates divide by the number of players | 0 | Duplicates would distort rates and group sizes | Untested. Phase 1: row count vs distinct `userid` | Taofeek Salami |
| A-004 | Each player stayed in one version for the whole test | Data | A player in both versions would blur the comparison | 0 | Contamination would shrink any real difference | Untested. Phase 1: check no `userid` appears in both versions | Taofeek Salami |
| A-005 | `retention_1` and `retention_7` mean the player played 1 and 7 days after install | Data | Both retention metrics depend on this definition | 0 | A different meaning would change how the primary result is read | Untested. Phase 1: review the Kaggle description and inspect the flag values for consistency. The exact operational definition cannot be fully verified from the dataset alone | Taofeek Salami |
| A-006 | `sum_gamerounds` covers the same 14-day window for every player | Data | The guardrail comparison depends on it | 0 | Unequal windows would make the game-round comparison unreliable | Untested. Phase 1: check against the Kaggle description. The window cannot be established from the data alone | Taofeek Salami |
| A-007 | The decision rule uses δ = 0 | Analytical | No business information supports a specific threshold | 0 | If the whole 95% interval lies above zero, the rule leads to "move the gate" even when the improvement is very small | Not testable. A pre-specified decision, not an empirical claim. δ = 0 reflects the absence of a justified business threshold, not a validated minimum meaningful effect. The observed difference, its confidence interval and the minimum detectable difference are reported so readers can judge practical importance | Taofeek Salami |
| A-008 | The Kaggle description of the game (gates, new installs during the test) is accurate | Data | The business context and population definition rely on it | 0 | If inaccurate, the context and population description in the write-up would need correcting | Partially Validated. The file's columns (player ID, version, game rounds, 1-day and 7-day retention flags) match the description. The gate mechanics and the new-install population are not recorded in the data and remain documentation-based. The listing names DataCamp project 184 as the source | Taofeek Salami |

---

# High-Risk Assumptions

| ID | Reason for High Risk | Mitigation Plan |
|----|----------------------|-----------------|
| A-002 | All causal wording depends on it, and the assignment method is not documented | Run the sample ratio test as a diagnostic before interpreting the effect. Investigate any material imbalance. A passed test does not establish random assignment, so causal statements are qualified while the assignment method remains undocumented |
| A-005 | The primary metric is built on this definition | Inspect the flag values and their consistency in Phase 1; state the definition and its source in the findings |
| A-007 | It sets the decision threshold, so a statistically positive result is not by itself evidence of a worthwhile improvement | Report the size of the difference, its confidence interval and the minimum detectable difference alongside the decision |

---

# Validation Status Definitions

| Status | Meaning |
|---------|---------|
| Untested | The assumption has not yet been evaluated. |
| Partially Validated | Some supporting evidence exists, but uncertainty remains. |
| Validated | Evidence supports the assumption within the scope of the project. |
| Rejected | Evidence indicates the assumption was incorrect. |
| No Longer Applicable | The assumption is no longer relevant due to changes in scope or analysis. |
| Not testable | A pre-specified decision or framing that data cannot confirm or reject. Recorded for transparency. |

---

# Review Checklist

Before completing the project, confirm:

- [ ] Every major assumption has been documented.
- [ ] Assumptions are clearly distinguished from observations.
- [ ] Validation status has been updated where applicable.
- [ ] High-risk assumptions have been identified.
- [ ] Business recommendations acknowledge any unresolved assumptions.