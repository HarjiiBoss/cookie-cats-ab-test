# Phase 1 — Data Loading, Cleaning & Exploration

> This document records all activities completed during **Phase 1 — Data Loading, Cleaning & Exploration**. The objective of this phase is to understand the available evidence, evaluate data quality, prepare the dataset for analysis, and generate initial hypotheses.

---

# Phase Objective

Understand the dataset before attempting to answer business questions.

The purpose of exploratory work is **not** to produce business conclusions.

It is to understand the evidence available for later analysis.

---

# Phase Status

| Field | Value |
|--------|-------|
| Status | In progress |
| Started | 2026-10-16 |
| Completed | |
| Owner | Taofeek Salami |
| Branch | `phase-1-data-preparation` |

---

# Data Acquisition

| Dataset | Source | Owner | Extraction Date | Refresh Frequency | Notes |
|----------|--------|-------|-----------------|-------------------|------|
| Cookie Cats A/B test | Kaggle: `yufengsui/mobile-games-ab-testing`, which states the data comes from DataCamp project 184 | Not stated. Kaggle uploader: yufengsui | 2026-10-16 | Not specified on the listing | Licence listed as Unknown. Downloaded manually from the Kaggle dataset page as a zip archive; the browser extracted the CSV automatically |

## Raw File Record

| Item | Value |
|------|-------|
| File | `data/raw/cookie_cats.csv` (not committed) |
| Size | 2.7 MB |
| SHA-256 | `9f53027065840672e77303281289988371d4a6b67c7dcd3bd4e6306a2a263dc8` |
| Rows | 90,189 data rows plus a header line. Confirmed by `awk` (90,190 records) and by the BigQuery load (90,189 rows, header not loaded) |
| File timestamp | 2019-10-28. This is the file's own timestamp from the download, not the date of the test |

`wc -l` reports 90,189 lines because the file has no newline after its last row, so it counts one line fewer than the file contains.

Anyone reproducing this project can run `shasum -a 256 data/raw/cookie_cats.csv` and compare the result with the value above to confirm they have the same file. The raw file is treated as read-only and is never opened or saved in a spreadsheet application.

---

## Raw BigQuery Table

| Item | Value |
|------|-------|
| Table | `cookie_cats.raw_cookie_cats` |
| Created by | `notebooks/01_data_loading.ipynb` (load job; re-running replaces the table) |
| Rows | 90,189 (header not loaded as data) |
| Schema | `userid`, `version`, `sum_gamerounds`, `retention_1`, `retention_7`, all `STRING` |
| Load settings | Explicit schema, no type detection, no bad records allowed |

All columns are stored as text, so the values match the file exactly. Types are checked and applied in SQL in the next steps. Tables in the BigQuery sandbox expire after 60 days, so the notebook is the way to recreate this table.

---

# Dataset Overview

One CSV file with five columns: `userid`, `version`, `sum_gamerounds`, `retention_1` and `retention_7`. The header and first rows were inspected from the terminal. The retention flags are stored as the text values `TRUE` and `FALSE`.

The file has no revenue or purchase column and no level-reached column. The analysis therefore cannot say anything about monetisation, or about which players reached the gate.

---

# Initial Data Profiling

Profiled with `sql/01_data_preparation.sql` (Section 1) on the raw table, before any changes.

| Item | Value |
|------|-------|
| Row Count | 90,189 |
| Column Count | 5 |
| Observation Unit | One player (90,189 distinct `userid` values) |
| Time Coverage | Not recorded in the data. There are no date or timestamp columns |
| Target Variable | `retention_7` (primary), `retention_1` (secondary) |
| Primary Identifier | `userid` |
| Group Sizes | `gate_30`: 44,700. `gate_40`: 45,489. The sample ratio test is run in Phase 3 |

## Game Rounds Distribution (all players)

| Statistic | Value |
|-----------|-------|
| Minimum | 0 |
| 25th percentile | 5 |
| Median | 16 |
| Mean | 51.87 |
| 75th percentile | 51 |
| 95th percentile | 221 |
| 99th percentile | 493 |
| Maximum | 49,854 |
| Players with 0 rounds | 3,994 |

The mean is above the 75th percentile, so the distribution is strongly right-skewed. The maximum is about 100 times the 99th percentile. Both the maximum and the zero-round players are investigated before any cleaning decision.

---

# Variable Summary

Document the major variable groups within the dataset.

| Variable Group | Description |
|---------------|-------------|
| | |

---

# Data Quality Assessment

## Missing Values

Summary: No missing or blank values in any column (query 1.2).

---

## Duplicate Records

Summary: No duplicate players. 90,189 rows and 90,189 distinct `userid` values (query 1.1). No player appears in both versions (query 1.5).

---

## Invalid Values

Summary: Every `userid` and `sum_gamerounds` value converts to a whole number (query 1.3). The retention flags contain only `TRUE` and `FALSE` (query 1.4).

---

## Outliers

Summary: One player in `gate_30` has 49,854 game rounds; the next highest is 2,961 (queries 2.1, 2.2). The value is kept and flagged with `is_extreme_gamerounds`. Above the 99th percentile (493) there are 898 players, with values rising steadily to 2,961; these are not treated as outliers.

---

## Inconsistent Categories

Summary: None. `version` contains only `gate_30` and `gate_40`; the retention flags contain only `TRUE` and `FALSE`, with no case or spacing variants (query 1.4).

---

## Timestamp Integrity

Summary: Not applicable. The data contains no dates or timestamps, so install dates, the test period and the timing of retention cannot be checked.

---

## Potential Data Leakage

Summary: No leakage into the outcome. `sum_gamerounds` was recorded after players were assigned to a version, so it is an outcome of the test, not a player characteristic. Splitting retention by game-round bands in Phase 2 is descriptive only, because the bands themselves may differ between versions.

---

## Other Data Quality Issues

Summary: 3,994 players (4.43%) recorded 0 game rounds; kept and flagged with `is_zero_gamerounds`. Of these, 111 are marked as retained at day 1, day 7 or both (query 2.3), which does not fully agree with a "came back and played" definition of retention. 26,971 players are retained at day 1 but not day 7 (query 2.4), so `retention_7` does not include day 1.

---

# Cleaning Decisions

| Activity | Reason | Related Documentation |
|----------|--------|-----------------------|
| Converted column types (text to INT64 and BOOL) | All values convert without loss | Cleaning Log |
| Flagged one extreme `sum_gamerounds` value (> 10,000) | Isolated value; kept for the main analysis, excluded in the sensitivity check | Cleaning Log |
| Flagged 3,994 zero-round players | Named in the charter's sensitivity check | Cleaning Log |
| No rows removed, no values changed | No evidence of invalid records | Cleaning Log |

Validation (Section 4 of `sql/01_data_preparation.sql`): the raw and clean tables match on row count, distinct players, group sizes, day-1 and day-7 retained counts, and total game rounds (4,678,325). The clean table has no NULL values, the expected types, 1 player flagged as extreme and 3,994 flagged with zero rounds.

Clean table: `cookie_cats.clean_cookie_cats`, 90,189 rows, built by Section 3 of `sql/01_data_preparation.sql`.

---

# Supporting Documentation Updated

Confirm supporting documentation has been maintained throughout this phase.

- [ ] Data Dictionary
- [ ] Cleaning Log
- [ ] Assumption Register
- [ ] Project Glossary

---

# Exploratory Data Analysis (EDA)

## Univariate Analysis

Summarize key distributional characteristics.

-

-

-

---

## Bivariate Analysis

Summarize important relationships identified between variables.

-

-

-

---

## Multivariate Analysis (if applicable)

Summarize higher-order relationships explored during EDA.

-

-

-

---

# Initial Observations

Record observations supported directly by the data.

These observations should describe patterns rather than explain causes.

-

-

-

---

# Initial Hypotheses

Document hypotheses generated during exploration.

These should guide later analysis and should **not** be presented as conclusions.

-

-

-

---

# Data Risks

Identify risks that may influence interpretation or later modelling.

-

-

-

---

# Related Documentation

- Project Information
- Data Dictionary
- Cleaning Log
- Assumption Register
- Project Glossary

---

# Phase Deliverables

- [ ] Clean dataset
- [ ] Data Dictionary updated
- [ ] Cleaning Log updated
- [ ] Assumption Register updated
- [ ] EDA completed
- [ ] Initial observations documented
- [ ] Initial hypotheses documented

---

# Exit Checklist

Proceed to **Phase 2 — Business Analysis** only when:

## Data Understanding

- [ ] Dataset fully profiled
- [ ] Variables understood
- [ ] Major business entities identified

---

## Data Quality

- [ ] Missing values assessed
- [ ] Duplicate records assessed
- [ ] Invalid values investigated
- [ ] Outliers reviewed
- [ ] Timestamp integrity verified

---

## Cleaning

- [ ] Cleaning decisions documented
- [ ] Raw data preserved
- [ ] Processed dataset created

---

## Documentation

- [ ] Data Dictionary updated
- [ ] Cleaning Log complete
- [ ] Assumption Register updated
- [ ] Phase documentation complete

---

# Phase Outcome

Summarize the overall condition of the dataset, the major findings from exploratory work, and confirm readiness to proceed to **Phase 2 — Business Analysis**.

---
