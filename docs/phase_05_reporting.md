# Phase 5 — Reporting, Communication & Publication

This document records the deliverables produced in Phase 5 and the checks made before publication. The findings and recommendation are in [executive_summary.md](executive_summary.md); the test results are in [phase_04_advanced_analysis.md](phase_04_advanced_analysis.md).

---

# Phase Status

| Field | Value |
|--------|-------|
| Status | Complete |
| Started | 2026-10-21 |
| Completed | 2026-10-25 |
| Owner | Taofeek Salami |
| Branch | `phase-5-reporting` |

---

# Deliverables

| Deliverable | Audience | Location |
|-------------|----------|----------|
| Executive summary | Decision-makers | [docs/executive_summary.md](executive_summary.md) |
| Dashboard | Decision-makers and reviewers | [Tableau Public](https://public.tableau.com/views/CookieCats-ShouldtheFirstGateStayatLevel30/CookieCatsShouldtheFirstGateStayatLevel30); workbook in [tableau/cookie_cats_dashboard.twbx](../tableau/cookie_cats_dashboard.twbx) |
| Dashboard data | Reviewers | Three aggregated CSVs in [tableau/data/](../tableau/data/), exported by section 4.7 of [notebooks/04_statistical_testing.ipynb](../notebooks/04_statistical_testing.ipynb) |
| Dashboard plan | Reviewers | [docs/tableau_blueprint.md](tableau_blueprint.md) |
| Presentation notes | Presenter | [docs/presentation_notes.md](presentation_notes.md) |
| README results section | All readers | [README.md](../README.md) |

The dashboard and its workbook contain aggregated results only. No player-level data is published.

---

# Publication Checks

| Check | Date | Result |
|-------|------|--------|
| Assumption register review | 2026-10-25 | All five review items met after one gap was closed: the retention definition (A-005, high risk) was not mentioned in the executive summary, so a Retention definition risk was added |
| Secrets scan of the full Git history | 2026-10-25 | Every local and remote branch searched for secret patterns and every committed file listed. No credential, `.env` or raw data file found. Recorded in [security_notes.md](security_notes.md) |
| Clean re-run of every notebook | 2026-10-25 | Notebooks 01 to 04 run from a restarted kernel without errors. The three dashboard CSVs and both chart images reproduced byte for byte; the only change was the BigQuery load job ID in notebook 01 |
| Dashboard figures against the notebooks | 2026-10-25 | Every KPI, interval and label on the published dashboard matches the Phase 4 results. Recorded in the blueprint's validation section |

---

# Issues and Resolutions

| Issue | What happened | Resolution |
|-------|---------------|------------|
| Wording that overstated the evidence | A second review of the executive summary found phrases such as "met the gate" and "still playing", which the data cannot support | Reworded to "assigned to" and "came back to play"; the causal reading made conditional on random assignment |
| Effect-size wording | The Phase 4 validity note said the true effect was likely nearer the lower end of the interval | Corrected to say estimates near the minimum detectable difference tend to overstate the effect, so the full interval is the safer summary |
| Workbook errors found on inspection | A saved copy of the workbook showed a duplicate p-value line, a sheet using the wrong label field, visible command buttons and an axis running past the data | Each fixed in Tableau before publishing |
| Difference chart axis | The axis showed two decimals and the last label was clipped | Axis set to one decimal place and the dashboard re-published |

---

# Exit Checklist

- [x] Executive summary written for decision-makers and checked against Phase 4
- [x] Dashboard published, with figures validated against the notebooks
- [x] Only aggregated data published
- [x] Limitations stated in the summary, dashboard and presentation notes
- [x] Assumption register reviewed
- [x] Git history scanned for secrets
- [x] Every notebook re-run from a restarted kernel
- [x] README updated with results and links
- [x] Repository ready to be made public

---

# Phase Outcome

The analysis is published as an executive summary, a Tableau Public dashboard and presentation notes, all recommending that the first gate stay at level 30. The pre-publication checks found one gap, the retention definition missing from the summary's risks, which was closed. The results reproduce exactly from a clean run. The repository is made public after this phase is merged into `main`.