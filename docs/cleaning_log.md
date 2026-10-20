# Cleaning Log

Every change between `cookie_cats.raw_cookie_cats` and `cookie_cats.clean_cookie_cats`, with the evidence behind it. The clean table is built by Section 3 of `sql/01_data_preparation.sql` and checked by Section 4.

---

# Dataset Information

| Field | Value |
|--------|-------|
| Project | Cookie Cats A/B Test |
| Dataset | `cookie_cats.raw_cookie_cats` → `cookie_cats.clean_cookie_cats` |
| Source | Kaggle `yufengsui/mobile-games-ab-testing` (`cookie_cats.csv`), originally DataCamp project 184 |
| Last Updated | 2026-10-17 |

---

# Cleaning Log

| Date | Variable(s) | Issue Observed | Extent / Frequency | Action Taken | Justification | Potential Impact |
|------|-------------|----------------|--------------------|--------------|---------------|------------------|
| 2026-10-17 | All five columns | Loaded as text so the raw table matches the file exactly | All 90,189 rows | Converted `userid` and `sum_gamerounds` to `INT64`, `retention_1` and `retention_7` to `BOOL` | Every value converts without loss (queries 1.3, 1.4) | None. Values unchanged, types applied |
| 2026-10-17 | `sum_gamerounds` | One value far above all others: 49,854, against a next-highest of 2,961 | 1 player (0.001%), `gate_30` | Kept. Flagged with `is_extreme_gamerounds` (`sum_gamerounds > 10,000`) | Isolated from every other player (queries 2.1, 2.2). The data cannot show whether it is an error, so it is not removed. The charter keeps all players in the main analysis | Raises the `gate_30` mean by about 1.1 rounds; the median is unaffected. Excluded in the Phase 3 sensitivity check |
| 2026-10-17 | `sum_gamerounds` | Players with 0 game rounds | 3,994 players (4.43%) | Kept. Flagged with `is_zero_gamerounds` (`sum_gamerounds = 0`) | Plausible behaviour (installed but no rounds recorded). The charter names this group for the sensitivity check | Excluded in the Phase 3 sensitivity check |
| 2026-10-17 | `retention_1`, `retention_7` | 3,599 players retained at day 7 but not day 1; 26,971 retained at day 1 but not day 7 | 3.99% and 29.90% of players | No change | Consistent with a measure taken at a later point, not a running total from install (query 2.4). No evidence of error | None |

---

# Missing Value Treatment

None required. No column has missing or blank values (query 1.2).

---

# Duplicate Records

None. 90,189 rows and 90,189 distinct `userid` values (query 1.1).

---

# Data Type Corrections

| Variable | Original Type | New Type | Reason |
|----------|---------------|----------|--------|
| `userid` | STRING | INT64 | Whole-number identifier; all values convert (query 1.3) |
| `sum_gamerounds` | STRING | INT64 | Count of rounds; all values convert (query 1.3) |
| `retention_1` | STRING | BOOL | Values are only `TRUE` / `FALSE` (query 1.4) |
| `retention_7` | STRING | BOOL | Values are only `TRUE` / `FALSE` (query 1.4) |

---

# Category Standardization

None required. `version` contains only `gate_30` and `gate_40` (query 1.4).

---

# Outlier Treatment

| Variable | Detection Method | Action Taken | Justification | Notes |
|----------|------------------|--------------|---------------|------|
| `sum_gamerounds` | Top-10 values and counts above thresholds (queries 2.1, 2.2) | Flagged, not removed or capped | Single isolated value; cause cannot be determined from the data | Threshold of 10,000 lies in the gap between 2,961 and 49,854; any threshold in that gap flags the same player |

---

# Records Removed

None. The clean table keeps all 90,189 rows.

---

# Variables Removed

None. Two flag columns were added: `is_extreme_gamerounds` and `is_zero_gamerounds`.

---

# Data Quality Findings

- 111 of the 3,994 zero-round players are marked as retained at day 1, day 7 or both (query 2.3). If retention means the player came back and played, these records do not fully agree with `sum_gamerounds`. The data does not show which field is responsible, so no change was made.
- 26,971 players are retained at day 1 but not at day 7 (query 2.4). `retention_7` therefore does not include day 1; it is not a running total from install.
- The data has no dates or timestamps, so install dates and the test period cannot be checked.

---

# Validation

Checked on 2026-10-17 with Section 4 of `sql/01_data_preparation.sql`.

- [x] Row counts reconciled (90,189 raw and clean; query 4.1)
- [x] Record counts verified (90,189 distinct `userid` in both tables; query 4.1)
- [x] Data types validated (query 4.2)
- [x] Business rules rechecked (group sizes, retained counts and flag counts as expected; queries 4.1, 4.3)
- [x] Summary statistics compared before and after cleaning (total game rounds 4,678,325 in both tables; query 4.1)
- [x] Cleaning decisions reflected in the Data Dictionary (2026-10-20)