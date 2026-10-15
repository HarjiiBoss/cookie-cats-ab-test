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

List the questions that must be answered to support the primary business question.

- [ ]
- [ ]
- [ ]
- [ ]

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

Document what is included within the project.

- [ ]
- [ ]
- [ ]

### Excluded

Document what is intentionally outside the project scope.

- [ ]
- [ ]
- [ ]

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

List the business metrics expected to evaluate success.

| Metric | Business Meaning | Notes |
|---------|------------------|-------|
| | | |

---

# Known Risks

Document risks identified during project planning.

| Risk | Potential Impact | Mitigation |
|------|------------------|------------|
| | | |

---

# Constraints

Document known project limitations.

Examples:

- Limited historical data
- Missing variables
- Time constraints
- Data quality concerns
- Resource limitations

- [ ]
- [ ]
- [ ]

---

# Initial Assumptions

| Assumption | Reason | Validation Planned |
|------------|--------|--------------------|
| Stakeholders are modelled on a typical mobile game studio | The dataset is public and has no real client | None possible. Stated in the README as a portfolio framing |

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
