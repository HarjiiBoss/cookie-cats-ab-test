# Data Dictionary

Reference for every column in the project tables. Updated whenever a variable is added or changed.

---

# Dataset Information

| Field | Value |
|--------|-------|
| Project | Cookie Cats A/B Test |
| Dataset | `cookie_cats.raw_cookie_cats` (raw, all text) and `cookie_cats.clean_cookie_cats` (typed, with flags) |
| Source | Kaggle `yufengsui/mobile-games-ab-testing` (`cookie_cats.csv`), originally DataCamp project 184 |
| Owner | Not stated on the listing. Kaggle uploader: yufengsui |
| Version | Single download, SHA-256 `9f53027065840672e77303281289988371d4a6b67c7dcd3bd4e6306a2a263dc8` |
| Extraction Date | 2026-10-16 |
| Last Updated | 2026-10-20 |

---

# Dataset Summary

One row per player in a Cookie Cats A/B test: 90,189 players, each assigned to `gate_30` (first gate at level 30) or `gate_40` (first gate at level 40), with the number of game rounds played and whether they were retained at day 1 and day 7. The clean table is the input for Phases 2 and 3.

---

# Variable Dictionary

| Variable | Data Type | Business Meaning | Valid Values / Units | Missingness | Cleaning Decisions | Notes |
|----------|-----------|------------------|----------------------|-------------|--------------------|------|
| `userid` | INT64 (raw: STRING) | Player identifier | Positive whole number; unique per row | 0 | Converted to INT64 | 90,189 distinct values |
| `version` | STRING | Test group the player was assigned to | `gate_30`, `gate_40` | 0 | None | 44,700 `gate_30`, 45,489 `gate_40` |
| `sum_gamerounds` | INT64 (raw: STRING) | Game rounds played after install | 0 to 49,854 rounds | 0 | Converted to INT64; extreme and zero values flagged, not changed | Per the Kaggle description, counted over the first 14 days after install (not verifiable from the data). Recorded after assignment, so it is an outcome of the test |
| `retention_1` | BOOL (raw: STRING) | Player returned 1 day after install | `TRUE`, `FALSE` | 0 | Converted to BOOL | 40,153 `TRUE` (44.52%) |
| `retention_7` | BOOL (raw: STRING) | Player returned 7 days after install | `TRUE`, `FALSE` | 0 | Converted to BOOL | 16,781 `TRUE` (18.61%). Not a running total from install: 26,971 players are retained at day 1 but not day 7 |

---

# Engineered Variables

| Variable | Data Type | Business Objective | Creation Logic | Interpretation | Assumptions | Limitations |
|----------|-----------|--------------------|----------------|----------------|-------------|-------------|
| `is_extreme_gamerounds` | BOOL | Identify the isolated extreme game-round value for the sensitivity check | `sum_gamerounds > 10000` | `TRUE` for 1 player | Any threshold between 2,961 and 49,854 flags the same player | Marks the value as unusual; does not show whether it is an error |
| `is_zero_gamerounds` | BOOL | Identify players with no recorded rounds for the sensitivity check | `sum_gamerounds = 0` | `TRUE` for 3,994 players | None | 111 of these players are marked as retained, so the flag and retention may not agree |

`rounds_band` (0, 1–9, 10–29, 30–99, 100–499, 500+) is created in `notebooks/02_cleaning_eda.ipynb` for exploration only and is not stored in any table.

---

# Categorical Variables

| Variable | Categories | Notes |
|----------|------------|------|
| `version` | `gate_30` (control: existing gate position), `gate_40` (treatment: gate moved to level 40) | No other values, no case or spacing variants |

---

# Date & Time Variables

None. The data contains no dates or timestamps.

---

# Target Variable

| Field | Description |
|--------|-------------|
| Variable | `retention_7` (primary); `retention_1` (secondary) |
| Business Meaning | Whether the player came back 7 days (or 1 day) after installing |
| Positive Class | `TRUE` (retained) |
| Negative Class | `FALSE` (not retained) |
| Class Balance | `retention_7`: 18.61% `TRUE`. `retention_1`: 44.52% `TRUE` |
| Notes | The exact definition is not confirmed (assumption A-005) |

---

# Primary Business Metrics

Defined in [PROJECT_INFO.md](../PROJECT_INFO.md) → Planned Success Metrics: 7-day retention (primary), 1-day retention (secondary), total game rounds (guardrail, exploratory).

---

# Data Quality Notes

Recorded in [cleaning_log.md](cleaning_log.md): no missing values or duplicates, one extreme game-round value and 3,994 zero-round players flagged, no rows removed.

---

# Variable Relationships

- Retention is higher in every successive game-round band (7-day retention from 0.7% at 0 rounds to 95.6% at 500 or more). If game rounds are counted over 14 days, players who return have more days in which to play, so part of this association may come from measurement.
- `sum_gamerounds` was recorded after assignment and may itself be affected by the gate placement. It should not be used to define groups when comparing versions.
- `retention_1` and `retention_7` are separate measures: 3,599 players are retained at day 7 only and 26,971 at day 1 only.

---

# External Reference Tables

None.

---

# Change Log

| Date | Change | Reason |
|------|--------|--------|
| 2026-10-20 | Dictionary created for raw and clean tables | Phase 1 profiling and cleaning complete |