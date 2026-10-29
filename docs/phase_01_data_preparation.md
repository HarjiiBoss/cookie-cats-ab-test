# Phase 1 — Data Loading, Cleaning & Exploration

This document records what was done and found during Phase 1. The project's question, metrics and decision rules are in [PROJECT_INFO.md](../PROJECT_INFO.md).

---

# Phase Status

| Field | Value |
|--------|-------|
| Status | Complete |
| Started | 2026-10-16 |
| Completed | 2026-10-20 |
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
| Group Sizes | `gate_30`: 44,700. `gate_40`: 45,489. The sample ratio test is run at the start of Phase 2 |

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

| Variable Group | Description |
|---------------|-------------|
| Identifier | `userid`: one row per player |
| Assignment | `version`: `gate_30` (control) or `gate_40` (treatment) |
| Engagement outcome | `sum_gamerounds`: game rounds played after install, recorded after assignment |
| Retention outcomes | `retention_1`, `retention_7`: whether the player returned at day 1 and day 7 |
| Analysis flags (clean table only) | `is_extreme_gamerounds`, `is_zero_gamerounds`: mark players for the Phase 4 sensitivity check |

Full definitions are in [data_dictionary.md](data_dictionary.md).

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

Summary: 3,994 players (4.43%) recorded 0 game rounds; kept and flagged with `is_zero_gamerounds`. Of these, 111 are marked as retained at day 1, day 7 or both (query 2.3; result saved in `outputs/query_2_3_zero_round_retention.csv`), which does not fully agree with a "came back and played" definition of retention. 26,971 players are retained at day 1 but not day 7 (query 2.4), so `retention_7` does not include day 1.

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

- [x] Data Dictionary
- [x] Cleaning Log
- [x] Assumption Register
- [x] Project Glossary

---

# Exploratory Data Analysis (EDA)

Notebook: `notebooks/02_cleaning_eda.ipynb`. All players are analysed together; the two versions are compared in Phase 2.

## Univariate Analysis

- 44.52% of players were retained at day 1 and 18.61% at day 7.
- Game rounds are heavily right-skewed: median 16, mean 51.87, 3,708 players above 250 rounds. The largest group played 0–4 rounds.

---

## Bivariate Analysis

- Retention flags: 46,437 players were retained at neither point, 13,182 at both, 26,971 at day 1 only and 3,599 at day 7 only.
- Game rounds and retention: retention is higher in every successive game-round band. 7-day retention ranges from 0.7% (0 rounds, 3,994 players) to 95.6% (500 or more rounds, 860 players).

---

## Multivariate Analysis (if applicable)

Not carried out in Phase 1. Comparisons between versions, including game-round bands by version, are part of Phase 2.

---

# Initial Observations

- Retention and game rounds are strongly associated across all players.
- Part of that association may come from measurement: if game rounds cover the 14 days after install, players who return have more days in which to play.
- Game rounds are too skewed for comparisons based on means alone; the median and rank-based methods planned for Phase 3 are supported by the data.
- Pandas and BigQuery give the same percentiles and counts for the clean table.

---

# Initial Hypotheses

These guide later phases and are not conclusions.

- Any effect of gate placement can only reach players who progress far enough to meet the gate. The data has no level column, so this cannot be checked directly. If many players stop before level 30, an effect among those who reach the gate would be diluted across all players, which makes the minimum detectable difference in Phase 4 important for reading the result.
- If gate placement affects how much players play, the distribution of game rounds may differ between versions. This is examined as the guardrail in Phase 2 and Phase 4.

---

# Data Risks

- No level-reached column: the analysis cannot identify which players met the gate.
- Retention definition is not fully confirmed (assumption A-005).
- Game rounds and retention may be partly linked by how they were measured, so the association between them cannot be read as cause.
- One extreme game-round value (49,854) affects means in `gate_30`; it is flagged for the sensitivity check.
- No dates or timestamps: the test period and the timing of retention cannot be checked.

---

# Related Documentation

- [PROJECT_INFO.md](../PROJECT_INFO.md)
- [data_dictionary.md](data_dictionary.md)
- [cleaning_log.md](cleaning_log.md)
- [assumption_register.md](assumption_register.md)
- [project_glossary.md](project_glossary.md)
- `sql/01_data_preparation.sql`, `notebooks/01_data_loading.ipynb`, `notebooks/02_cleaning_eda.ipynb`

---

# Phase Deliverables

- [x] Clean dataset (`cookie_cats.clean_cookie_cats`)
- [x] Data Dictionary updated
- [x] Cleaning Log updated
- [x] Assumption Register updated
- [x] EDA completed
- [x] Initial observations documented
- [x] Initial hypotheses documented

---

# Exit Checklist

## Data Understanding

- [x] Dataset fully profiled
- [x] Variables understood
- [x] Major business entities identified (players and the two test groups)

---

## Data Quality

- [x] Missing values assessed
- [x] Duplicate records assessed
- [x] Invalid values investigated
- [x] Outliers reviewed
- [x] Timestamp integrity verified (not applicable: the data has no dates or timestamps)

---

## Cleaning

- [x] Cleaning decisions documented
- [x] Raw data preserved
- [x] Processed dataset created

---

## Documentation

- [x] Data Dictionary updated
- [x] Cleaning Log complete
- [x] Assumption Register updated
- [x] Phase documentation complete

---

# Phase Outcome

The data is complete and consistent: 90,189 players, one row each, with no missing, duplicate or invalid values. The clean table keeps every player, applies column types and adds two flags for the sensitivity check, and it reconciles exactly with the raw table. Exploration showed heavily skewed game rounds and a strong association between game rounds and retention, which may partly come from how the two were measured. The data cannot show which players reached the gate, the exact retention definition or the test period; these limits are recorded in the assumption register and carry into Phase 2.
