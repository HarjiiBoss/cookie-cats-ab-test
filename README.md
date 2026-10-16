# Cookie Cats A/B Test

Analysis of a mobile game A/B test to decide where the first progression gate should sit. Built with the Data Analysis Playbook v3.1.

> **Status:** Phase 0 complete. Phase 1 (data loading, cleaning and exploration) is next; findings will be added when the project is complete.

---

# Business Problem

Cookie Cats is a mobile puzzle game. According to the Kaggle dataset description, players meet gates at set levels, where they must wait or make an in-app purchase before continuing. The first gate sits at level 30. A test moved it to level 40 for some players, and the team needs to decide whether to move the gate, keep it at level 30, or keep testing before making a change.

# Business Question

Does moving the first gate from level 30 to level 40 change player retention among players who installed the game during the test?

---

# Approach

- **Primary metric:** 7-day retention. **Secondary:** 1-day retention. **Guardrail (exploratory):** total game rounds
- **Decision rule, set before any data was examined:** two-sided tests at the 5% significance level. With Δ = 7-day retention for gate_40 minus 7-day retention for gate_30: if the 95% confidence interval for Δ is entirely above zero, move the gate to level 40; if it is entirely below zero, keep it at level 30; otherwise, collect more evidence. A statistically clear difference does not by itself show that the difference is large enough to matter commercially, so its size is reported alongside the decision
- **Validity checks:** sample ratio test before reading any effect, plus robustness checks reported alongside the main result
- **Stack:** BigQuery (SQL), Python in Jupyter, Tableau

Full scoping (hypotheses, metric definitions, scope, risks and assumptions): [PROJECT_INFO.md](PROJECT_INFO.md)

This is a portfolio project on public learning data. The stakeholders are modelled on a typical mobile game studio, and the findings are not evidence about any real game.

---

# Dataset

| Item | Details |
|------|---------|
| Source | Kaggle: `yufengsui/mobile-games-ab-testing` |
| Expected contents (per the Kaggle description) | Player ID, assigned version (gate_30 or gate_40), game rounds played, and 1-day and 7-day retention flags. Row uniqueness and field definitions are checked in Phase 1 |
| Licence | To be confirmed in Phase 1 |
| Rows, columns, time period | To be recorded in Phase 1 |

The data is not stored in this repository. See Reproducibility for how to download it.

---

# Progress

- [x] Phase 0 — Scoping & Project Setup
- [ ] Phase 1 — Data Loading, Cleaning & Exploration
- [ ] Phase 2 — Business Analysis
- [ ] Phase 2.5 — Analytical Method Selection
- [ ] Phase 3 — Advanced Analytics & Modelling
- [ ] Phase 4 — Reporting, Communication & Publication

---

# Reproducibility

Requirements: Python 3.13, the Google Cloud CLI, and a Google account.

1. Clone the repository and create the environment:
```bash
   git clone <repository-url>
   cd cookie-cats-ab-test
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
```
2. Create a Google Cloud project and use BigQuery in sandbox mode. A billing account is not required for the sandbox, which has its own limits (for example, no DML statements and tables that expire after 60 days). Check in the BigQuery console that the project shows as a sandbox before continuing. Then log in and create the dataset:
```bash
   gcloud config set project YOUR_PROJECT_ID
   gcloud auth application-default login
   gcloud auth application-default set-quota-project YOUR_PROJECT_ID
   bq --location=US mk --dataset YOUR_PROJECT_ID:cookie_cats
```
3. Copy `.env.example` to `.env` and fill in your project ID.
4. Download the dataset from Kaggle into `data/raw/`. Exact steps are added in Phase 1.
5. Run the notebooks in `notebooks/` in numbered order. Notebook names, prerequisites and execution instructions are added here as each phase is completed.

No service account key file is used; authentication relies on your own Google login.

---

# Repository Structure

```text
cookie-cats-ab-test/
├── assets/            # Images used in documentation
├── data/
│   ├── raw/           # Downloaded data (not committed)
│   └── processed/     # Cleaned outputs (not committed)
├── docs/              # Phase documents, registers and notes
├── notebooks/         # Jupyter notebooks, run in numbered order
├── outputs/           # Finished charts (chart_*.png) and result tables
├── reports/           # Written reports
├── sql/               # BigQuery SQL scripts, run in numbered order
├── tableau/           # Dashboard files
├── .env.example       # Template for local configuration
├── PROJECT_INFO.md    # Project charter
├── README.md
└── requirements.txt
```

---

# Documentation

| Document | Purpose |
|----------|---------|
| [PROJECT_INFO.md](PROJECT_INFO.md) | Project charter: question, metrics, decision rules, scope, risks |
| [docs/phase_00_setup.md](docs/phase_00_setup.md) | Phase 0 record: setup, issues and exit checklist |
| [docs/assumption_register.md](docs/assumption_register.md) | Assumptions and their validation status |
| [docs/security_notes.md](docs/security_notes.md) | Security checks and data handling |
| [docs/documentation_index.md](docs/documentation_index.md) | Index of all project documents |

---

# License

The code and documentation in this repository are released under the MIT License. The dataset is not covered by this licence; its terms are set by its Kaggle listing.