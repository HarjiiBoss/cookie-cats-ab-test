# Phase 0 — Scoping & Project Setup

This document records what was done and decided during Phase 0. The scoping decisions themselves (business question, hypotheses, metrics, decision rules, scope, risks and assumptions) are kept in [PROJECT_INFO.md](../PROJECT_INFO.md) so they exist in one place only.

---

# Phase Status

| Field | Value |
|--------|-------|
| Status | Complete |
| Started | 2026-10-15 |
| Completed | 2026-10-16 |
| Owner | Taofeek Salami |
| Branch | `phase-0-scoping` |

---

# Decisions Made

| Decision | Where it is recorded |
|----------|----------------------|
| Business question: does moving the first gate from level 30 to level 40 change player retention? | PROJECT_INFO.md → Primary Business Question |
| Primary metric 7-day retention, secondary 1-day retention, guardrail total game rounds (exploratory) | PROJECT_INFO.md → Planned Success Metrics |
| Two-sided tests at α = 0.05. The decision uses zero as the threshold for the direction of the 7-day retention difference (δ = 0), read from its 95% confidence interval. No separate threshold for practical business importance was set | PROJECT_INFO.md → Decision Rules |
| Game rounds reported and interpreted but not used to block the decision | PROJECT_INFO.md → Decision Rules |
| All players kept in the main analysis (intent-to-treat); exclusions used only for sensitivity checks | PROJECT_INFO.md → Supporting Analytical Questions; Known Risks |
| Stakeholders modelled on a typical mobile game studio | PROJECT_INFO.md → Stakeholders; Initial Assumptions |

All decision rules were set before the dataset was downloaded or examined.

---

# Environment Setup

| Component | Setting |
|-----------|---------|
| Repository | `cookie-cats-ab-test`, private on GitHub, created with `new_project.py` from Playbook v3.1 |
| Branching | Work on `phase-N-description` branches, merged into `main` by pull request |
| Python | 3.13.5 in a project virtual environment (`.venv`), packages from `requirements.txt` |
| Google Cloud project | `cookie-cats-ab-taofeek`, with no billing account linked (BigQuery sandbox) |
| BigQuery dataset | `cookie_cats`, location US |
| Authentication | Application Default Credentials from the author's Google login. No service account key file |
| Configuration | `.env` (not committed) holds the project ID, dataset and location. `.env.example` is committed as a template |
| Connection test | Listing datasets and running `SELECT 1` from Python inside `.venv` both succeeded |

---

# Issues and Resolutions

| Issue | What happened | Resolution |
|-------|---------------|------------|
| Billing account | The Google Cloud free trial signup required a prepayment, which was not made. The billing account was closed but remained linked to the project | Billing was disabled on the project, so no billing account is linked and BigQuery runs in sandbox mode |
| Missing virtual environment | `.venv` did not exist in the project folder, so the earlier package install had not gone into a project environment | Created `.venv` with `python3 -m venv .venv` and installed `requirements.txt` into it |
| Home folder under Git | The home folder was a Git repository linked to an earlier project's remote. Only one commit (`README.md`) had been pushed from it | Renamed `~/.git` to a backup folder. Verified that the home folder is no longer a repository and that this project is not nested inside one |
| BigQuery Storage warning | Query results printed a warning that the BigQuery Storage package was missing | Added `google-cloud-bigquery-storage` to `requirements.txt` |
| `gcloud init` error | The Compute Engine API check failed during `gcloud init` | No action. This project does not use Compute Engine, and the CLI configuration completed |

Safety measures added during setup: credential file patterns in `.gitignore`, and `.env` confirmed as ignored by Git.

---

# Concept Notes

**Hypotheses and two-sided tests.** The null hypothesis (H₀) says the versions do not differ. The test measures how surprising the data would be if H₀ were true. A two-sided test looks for a difference in either direction, which matches a question about whether retention changes. Choosing one side after seeing the data can make the evidence appear stronger than it is.

**Significance level (α).** α = 0.05 is the chosen threshold for statistical significance. If the null hypothesis were true and the test’s assumptions held, a test at this level would incorrectly reject H₀ about 5% of the time over repeated tests.

**Decision rules set in advance.** Writing down what each result means before seeing the data helps prevent the threshold from being moved to fit the result. “Collect more evidence” is a real outcome. It means the sample could not distinguish the versions with sufficient confidence, not that they have the same retention.

**Primary, secondary and guardrail metrics.** The primary metric decides the outcome, and there is only one. The secondary metric helps explain the result but cannot decide it. A guardrail checks for potential harm elsewhere. In this project, the guardrail is exploratory because no threshold for harm could be justified.

**Intent-to-treat.** Every player is analysed in the group they were assigned to, including players who never reached the gate. If assignment was random, this approach preserves the original group comparison rather than selecting players based on what happened after assignment. Including all players may make a gate-related effect harder to detect if many players never reached the gate.

**Sample ratio test.** Checks whether the group sizes match the expected split. A failed test is a warning sign that the allocation may not match expectations. A passed test does not prove assignment was random.

**Minimum detectable difference vs minimum effect of interest.** The minimum detectable difference is the smallest effect the sample could reliably detect under specified statistical assumptions. The minimum effect of interest (δ) is the smallest effect worth acting on. The first describes the statistical capability of the analysis; the second describes the business decision.

**BigQuery structure and access.** A project holds datasets, and a dataset holds tables (`project.dataset.table`). Application Default Credentials allow local tools to authenticate using the author’s Google account without keeping a service account key file in the repository. The BigQuery sandbox has no DML, a 10 GiB lifetime storage cap and a 60-day table expiry.

**Single source of truth.** Each decision is documented in one authoritative place, and other documents refer back to it, so duplicated copies do not drift apart.

---

# Exit Checklist

## Business

- [x] Business problem clearly defined
- [x] Business question documented
- [x] Success criteria agreed
- [x] Stakeholders identified
- [x] Project scope established
- [x] Decision rules set before data access

## Data

- [x] Required dataset identified
- [ ] Data ownership and licence confirmed (moved to Phase 1, with the download)
- [ ] Data availability verified (moved to Phase 1, with the download)

## Technical

- [x] Repository structure created
- [x] Development environment configured
- [x] Version control initialised and pushed
- [x] BigQuery reachable from Python

## Documentation

- [x] PROJECT_INFO.md completed
- [x] README initialised
- [x] Phase documentation updated
- [x] Assumption register started
- [x] Security notes started

---

# Phase Outcome

The business question, metrics and decision rules were documented before the dataset was downloaded or examined. The development environment is configured and ready for Phase 1. Confirming the dataset's licence and downloading the data are the first Phase 1 tasks. The remaining documentation items are tracked in the exit checklist above.