# Cookie Cats A/B Test

> **Project Information**
>
> This document serves as the authoritative project charter for the analysis. It captures the business context, objectives, scope, assumptions, constraints, and planning decisions established during **Phase 0 — Scoping & Project Setup** of the Data Analysis Playbook.

---

# Project Overview

| Field | Value |
|--------|-------|
| Project Title | Cookie Cats A/B Test |
| Repository | cookie-cats-ab-test |
| Industry | Mobile Gaming |
| Analytics Domain | Product Analytics |
| Project Type | Portfolio Project |
| Status | Phase 0 — Scoping |
| Author | Taofeek Salami |
| Date Created | 2026-10-15 |
| Last Updated | 2026-10-15 |

---

# Business Context

Describe the business environment surrounding the project.

Consider including:

- Organization or industry background
- Current business situation
- Existing challenges
- Why this analysis is being performed
- Relevant operational context

---

# Business Problem

Cookie Cats uses gates at set levels, where a player must wait or make an in-app purchase before continuing. The first gate is at level 30. The team ran a test that moved it to level 40 for some players. They need to decide whether to move the first gate to level 40, keep it at level 30, or keep testing before making a change.

---

# Primary Business Question

Does moving the first gate from level 30 to level 40 change player retention among players who installed the game during the test?

**Decision supported:** Move the gate to level 40, keep it at level 30, or collect more evidence. The rule for choosing between these options is set during Phase 0, before any data is examined.

---

# Supporting Analytical Questions

- Were players split between gate_30 and gate_40 in the expected ratio?
- How do 1-day and 7-day retention compare between the two versions?
- Does the number of game rounds played differ between the two versions?
- Does the conclusion hold when extreme and zero-round players are excluded? (Sensitivity check only. The main analysis keeps all players.)
- What is the smallest retention difference this sample could reliably detect?

---

# Hypotheses

All tests are two-sided. The direction of any effect is not assumed in advance.

| Metric | Type | Null Hypothesis (H₀) | Alternative Hypothesis (H₁) |
|--------|------|----------------------|-----------------------------|
| 7-day retention | Primary | 7-day retention is the same for gate_30 and gate_40 | 7-day retention differs between gate_30 and gate_40 |
| 1-day retention | Secondary | 1-day retention is the same for gate_30 and gate_40 | 1-day retention differs between gate_30 and gate_40 |
| Total game rounds | Guardrail | The distribution of game rounds is the same for gate_30 and gate_40 | The distribution of game rounds differs between gate_30 and gate_40 |

For the retention metrics, the formal hypotheses are H₀: p₃₀ = p₄₀ and H₁: p₃₀ ≠ p₄₀, where p₃₀ and p₄₀ are the retention proportions for gate_30 and gate_40.

---

# Stakeholders

| Stakeholder | Role | Decision Supported | Needs from the Result |
|-------------|------|--------------------|-----------------------|
| Product team | Decision-maker | Move the first gate to level 40, keep it at level 30, or keep testing | A recommendation and how confident it is |
| Game design team | Implements the gate placement | How level progression is set up if the gate moves | The size of the retention difference and what happened to game rounds |
| Monetisation team | Affected by the change | Whether gate placement affects in-app purchases | A clear statement of what the analysis can and cannot say about revenue. This cannot be answered if the data has no revenue column (to confirm in Phase 1) |

---

# Business Objectives

Describe what the organization hopes to achieve.

- [ ]
- [ ]
- [ ]

---

# Success Criteria

Define what constitutes a successful project.

Examples may include:

- Business questions answered
- Decision supported
- Dashboard delivered
- Model validated
- Documentation completed

- [ ]
- [ ]
- [ ]

---

# Scope

## Included

- Comparison of 7-day retention (primary) and 1-day retention (secondary) between gate_30 and gate_40
- Total game rounds as an exploratory guardrail
- Validity checks (sample ratio test) and robustness checks (bootstrap interval, rerun without extreme and zero-round players)
- The smallest retention difference the sample could reliably detect
- A Tableau dashboard and executive summary for the product team

## Excluded

- Revenue and in-app purchase effects (no revenue column is expected; to confirm in Phase 1)
- Retention beyond day 7
- Reasons why players stop playing, which the data does not record
- Predictive modelling

---

# Expected Deliverables

Select or modify as appropriate.

- [ ] README
- [ ] Executive Summary
- [ ] Technical Report
- [ ] SQL Scripts
- [ ] Python Notebooks
- [ ] Dashboard
- [ ] Presentation
- [ ] Data Dictionary
- [ ] Cleaning Log
- [ ] Assumption Register
- [ ] Project Glossary

---

# Available Data

| Dataset | Source | Owner | Refresh Frequency | Status |
|----------|--------|-------|-------------------|--------|
| | | | | |

---

# Planned Analytical Approach

Describe the anticipated workflow.

Example:

- Descriptive analysis
- Business analysis
- Statistical testing
- Predictive modelling
- Dashboard development

---

# Planned Success Metrics

| Metric | Business Meaning | Notes |
|---------|------------------|-------|
| 7-day retention | Share of players who came back to play 7 days after installing | Primary metric. Decides the outcome |
| 1-day retention | Share of players who came back to play 1 day after installing | Secondary metric. Supports interpretation, does not decide alone |
| Total game rounds | Number of rounds a player played after installing | Guardrail. A meaningful decline may prevent a move to level 40 |

## 7-day retention (primary)

| Question | Answer |
|----------|--------|
| What is measured? | Whether a player came back and played 7 days after installing |
| Why does it matter? | It is the later of the two retention points in the data and the closer signal of whether players stay with the game |
| How is it calculated? | Players with `retention_7` = TRUE divided by all players in the version |
| What assumptions exist? | `retention_7` means the player played on day 7 after install. Whether it means exactly day 7 or any day up to day 7 is not stated (to confirm in Phase 1) |
| What are the limitations? | Records one point in time only. Includes players who never reached level 30 and never met a gate, which adds noise. Says nothing about revenue |
| How will decisions change? | This metric decides between moving the gate, keeping it at level 30, or collecting more evidence, using the decision rules set in Phase 0 |

## 1-day retention (secondary)

| Question | Answer |
|----------|--------|
| What is measured? | Whether a player came back and played 1 day after installing |
| Why does it matter? | It shows whether any difference between versions appears early |
| How is it calculated? | Players with `retention_1` = TRUE divided by all players in the version |
| What assumptions exist? | `retention_1` means the player played on day 1 after install (to confirm in Phase 1) |
| What are the limitations? | 1-day retention measures early retention, but its relationship to the gate placement may be limited because players may not have reached level 30 by that point. The dataset does not establish when individual players reached the gate |
| How will decisions change? | It supports interpretation of the primary result. It does not decide the outcome on its own, and it is tested with a correction for multiple comparisons |

## Total game rounds (guardrail)

| Question | Answer |
|----------|--------|
| What is measured? | The number of game rounds a player played after installing |
| Why does it matter? | It checks that a change in gate placement does not reduce how much players play |
| How is it calculated? | `sum_gamerounds` per player, compared between versions using the method chosen in Phase 2.5. Reported with median and mean |
| What assumptions exist? | The Kaggle description gives the window as the first 14 days after install. This is to be confirmed in Phase 1. If it cannot be established, the uncertainty is documented rather than assumed |
| What are the limitations? | The observation window does not match the 1-day and 7-day retention windows. Counts are likely to be skewed. More rounds is not always better for the business, for example if players progress faster and reach later gates sooner |
| How will decisions change? | A meaningful decline in game rounds for gate_40 may prevent moving the gate, even if 7-day retention improves. The threshold for a meaningful decline is set in Phase 0, before examining the results |

---

# Known Risks

| Risk | Potential Impact | Mitigation |
|------|------------------|------------|
| Players were not randomly assigned | A difference between versions could not be read as caused by the gate | Sample ratio test in Phase 3; conclusions qualified if assignment cannot be supported |
| No level-reached column | Players who never met the gate are included, which adds noise and makes a real effect harder to detect | All players are analysed (intent-to-treat); minimum detectable difference reported in Phase 3 |
| No revenue column | The analysis cannot say anything about monetisation | Confirmed in Phase 1; stated as a limitation for the monetisation team |
| Game rounds are skewed with extreme values | Mean-based comparisons could mislead | Method chosen in Phase 2.5 accounts for skew; sensitivity rerun without extreme and zero-round players |
| BigQuery setup problems | Delays to Phase 1 | Analysis plan does not change if a local SQL database is used instead |

---

# Constraints

- The data is public learning data. Findings are not evidence about any real game.
- The test cannot be extended. If the result is "collect more evidence", this project can only recommend further testing, not run it.
- Retention is recorded at day 1 and day 7 only, so retention curves are not possible.
- No business cost data is available (value of a retained player, cost of the change).

---

# Initial Assumptions

| Assumption | Reason | Validation Planned |
|------------|--------|--------------------|
| Stakeholders are modelled on a typical mobile game studio | The dataset is public and has no real client | None possible. Stated in the README as a portfolio framing |
| Players were randomly assigned to gate_30 or gate_40 | Needed for a causal reading of any difference | Indirect only: sample ratio test in Phase 3. The assignment method is not documented |
| Each row is one unique player | Retention rates divide by the number of players | Phase 1: compare row count with distinct `userid` count |
| Each player stayed in one version for the whole test | A player seeing both versions would blur the comparison | Phase 1: check that no `userid` appears in both versions |
| `retention_1` and `retention_7` mean the player played 1 and 7 days after install | Both retention metrics depend on this definition | Phase 1: check values. The exact definition comes from the Kaggle description and cannot be fully verified from the data |
| `sum_gamerounds` covers the same window for every player | The guardrail comparison depends on it | Phase 1: check against the Kaggle description. Cannot be verified from the data alone |
| The decision rule uses δ = 0 | No business information supports a specific threshold | Not testable. Stated in Decision Rules and in the findings |

---

# Dependencies

List anything required before analysis can begin.

Examples:

- Database access
- API credentials
- Data approval
- Subject matter expertise

- [ ]
- [ ]
- [ ]

---

# Planned Workflow

Track project progress.

- [ ] Phase 0 — Scoping & Project Setup
- [ ] Phase 1 — Data Loading, Cleaning & Exploration
- [ ] Phase 2 — Business Analysis
- [ ] Phase 2.5 — Analytical Method Selection
- [ ] Phase 3 — Advanced Analytics & Modelling
- [ ] Phase 4 — Reporting, Communication & Publication

---

# Project Notes

To confirm in Phase 1:

- Whether the data has a revenue or purchase column
- Whether the data has a level-reached column
- What a gate does (wait or pay). Taken from the Kaggle dataset description, not from the data
- That the players are new installs during the test. Taken from the Kaggle dataset description, not from the data

---

# Revision History

| Date | Version | Summary |
|------|---------|---------|
| 2026-10-15 | 1.0 | Initial project charter created. |
