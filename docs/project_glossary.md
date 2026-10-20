# Project Glossary

Terms used in this project's documentation, code and findings. Definitions are written for this project.

---

# Glossary

| Term | Category | Definition | Notes |
|------|----------|------------|------|
| A/B test | Business | An experiment in which users are split into groups that each get a different version, so outcomes can be compared | Here: `gate_30` vs `gate_40` |
| Control | Business | The group that keeps the existing version | `gate_30` |
| Gate | Business | A point in the game where a player must wait or make an in-app purchase before continuing | Description from the Kaggle listing |
| Guardrail metric | Business | A metric checked for unintended harm alongside the main result | Total game rounds; exploratory in this project |
| Primary metric | Business | The single metric that decides the outcome | 7-day retention |
| Retention (1-day, 7-day) | Business | Whether a player came back 1 or 7 days after installing | Exact definition not confirmed (A-005) |
| Secondary metric | Business | A metric that supports interpretation but does not decide the outcome | 1-day retention |
| Treatment | Business | The group that gets the changed version | `gate_40` |
| Extreme game-round flag | Dataset | `is_extreme_gamerounds`: marks `sum_gamerounds` above 10,000 | 1 player |
| Raw table | Dataset | `raw_cookie_cats`: the CSV loaded unchanged, every column as text | Never edited |
| Clean table | Dataset | `clean_cookie_cats`: typed columns and two flag columns, built from the raw table | Input for Phases 2 and 3 |
| Zero-round flag | Dataset | `is_zero_gamerounds`: marks players with 0 game rounds | 3,994 players |
| Application Default Credentials (ADC) | Technical | Google login stored on the local machine, outside the repository, used by code to access BigQuery | No key file needed |
| BigQuery sandbox | Technical | Free BigQuery use without a billing account | No DML; tables expire after 60 days; 10 GiB storage |
| CAST / SAFE_CAST | Technical | Convert a value's type. `CAST` stops the query on a value it cannot convert; `SAFE_CAST` returns NULL instead | `SAFE_CAST` used only to count failures |
| Checksum (SHA-256) | Technical | A fixed-length code calculated from a file's contents; any change to the file changes the code | Identifies the downloaded file |
| CTAS | Technical | `CREATE TABLE ... AS SELECT`: creates a table from a query result | Builds the clean table |
| CTE | Technical | `WITH name AS (...)`: a named temporary result used within one query | |
| DDL | Technical | Statements that define structure: `CREATE`, `ALTER`, `DROP` | Allowed in the sandbox |
| DML | Technical | Statements that change rows: `INSERT`, `UPDATE`, `DELETE` | Not allowed in the sandbox |
| Dry run | Technical | BigQuery's estimate of data a query will scan, shown before it runs | BigQuery charges by data scanned |
| Idempotent | Technical | Gives the same result however many times it is run | `CREATE OR REPLACE`, `IF NOT EXISTS`, `WRITE_TRUNCATE` |
| Load job | Technical | Uploads a whole file into a BigQuery table in one operation | Used for the raw table |
| Reconciliation | Technical | Comparing counts and totals between two versions of data to confirm nothing changed unintentionally | Query 4.1 |
| Window function | Technical | A calculation across rows that keeps every row, written with `OVER (...)` | Used for percentiles and percentages |
| Confidence interval | Analytical | A range of plausible values for the true difference, given the data | 95% interval for the 7-day retention difference |
| Intent-to-treat | Analytical | Every player is analysed in the group they were assigned to, whether or not they reached the gate | Main analysis keeps all players |
| Minimum detectable difference | Analytical | The smallest effect the sample could reliably detect | Reported in Phase 4 |
| Minimum effect of interest (δ) | Analytical | The smallest effect worth acting on | Set to 0 in Decision Rules |
| Post-treatment variable | Analytical | A variable measured after assignment that the change may have affected | `sum_gamerounds` |
| Right skew | Analytical | A distribution with most values low and a long tail of high values; the mean sits above the median | Game rounds: median 16, mean 51.87 |
| Sample ratio test | Analytical | Checks whether group sizes match the expected split | Phase 4; a pass does not prove random assignment |
| Sensitivity check | Analytical | Repeating an analysis with a different choice, such as excluding flagged players, to see if the conclusion changes | Does not replace the main analysis |
| Significance level (α) | Analytical | The accepted false-positive rate | α = 0.05, two-sided |
| Two-sided test | Analytical | A test that looks for a difference in either direction | All tests in this project |
| EDA | Acronym | Exploratory data analysis | |
| ITT | Acronym | Intent-to-treat | |
| MDD | Acronym | Minimum detectable difference | |
| SRM | Acronym | Sample ratio mismatch, which the sample ratio test checks for | |

---

# Change Log

| Date | Change | Reason |
|------|--------|--------|
| 2026-10-20 | Glossary created | Phase 1 introduced most of the project's terminology |