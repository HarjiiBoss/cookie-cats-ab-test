/*
===============================================================================
Project      : Cookie Cats A/B Test
Repository   : cookie-cats-ab-test
Author       : Taofeek Salami
Date Created : 2026-10-15
Last Updated : 2026-10-17

Phase        : Phase 1 - Data Loading, Cleaning & Exploration
Purpose      : Profile the raw table, investigate data quality issues, and
               build the clean table.
Status       : In progress (Section 1 complete)

Business Question
-----------------
Does moving the first gate from level 30 to level 40 change player retention
among players who installed the game during the test?

Notes
-----
- Run in the BigQuery console with project cookie-cats-ab-taofeek selected.
  Table names omit the project ID so the script runs in any project.
- Input: cookie_cats.raw_cookie_cats, loaded by notebooks/01_data_loading.ipynb.
  Every column is STRING, so types are checked here before any conversion.
- Profiling queries only read data. Nothing is changed in Section 1.
===============================================================================
*/


-- =============================================================================
-- Section 1 — Profiling (raw table)
-- =============================================================================

-- Purpose:
-- Describe the raw data before any changes: size, uniqueness, missing values,
-- whether text values convert to the intended types, category values and the
-- spread of game rounds.


-- 1.1 Row count, distinct players and duplicate IDs
-- If every row is one player, distinct_userids equals total_rows.
SELECT
  COUNT(*)                          AS total_rows,
  COUNT(DISTINCT userid)            AS distinct_userids,
  COUNT(*) - COUNT(DISTINCT userid) AS duplicate_id_rows
FROM cookie_cats.raw_cookie_cats;


-- 1.2 Missing or blank values per column
-- An empty field in the CSV loads as NULL. TRIM(...) = '' also catches values
-- that contain only spaces.
SELECT
  COUNTIF(userid         IS NULL OR TRIM(userid)         = '') AS missing_userid,
  COUNTIF(version        IS NULL OR TRIM(version)        = '') AS missing_version,
  COUNTIF(sum_gamerounds IS NULL OR TRIM(sum_gamerounds) = '') AS missing_sum_gamerounds,
  COUNTIF(retention_1    IS NULL OR TRIM(retention_1)    = '') AS missing_retention_1,
  COUNTIF(retention_7    IS NULL OR TRIM(retention_7)    = '') AS missing_retention_7
FROM cookie_cats.raw_cookie_cats;


-- 1.3 Values that would fail to convert to whole numbers
-- SAFE_CAST returns NULL when a value cannot be converted. Counting those cases
-- (for values that are not already NULL) shows whether conversion is safe.
-- Both counts must be 0 before Section 3 converts these columns.
SELECT
  COUNTIF(userid         IS NOT NULL AND SAFE_CAST(userid         AS INT64) IS NULL) AS non_integer_userid,
  COUNTIF(sum_gamerounds IS NOT NULL AND SAFE_CAST(sum_gamerounds AS INT64) IS NULL) AS non_integer_sum_gamerounds
FROM cookie_cats.raw_cookie_cats;


-- 1.4 Distinct values in the categorical columns
-- Shows every value that appears, so spelling, case or spacing variants
-- (for example 'gate_30 ' or 'true') would be visible.
SELECT 'version' AS column_name, version AS value, COUNT(*) AS row_count
FROM cookie_cats.raw_cookie_cats GROUP BY version
UNION ALL
SELECT 'retention_1', retention_1, COUNT(*)
FROM cookie_cats.raw_cookie_cats GROUP BY retention_1
UNION ALL
SELECT 'retention_7', retention_7, COUNT(*)
FROM cookie_cats.raw_cookie_cats GROUP BY retention_7
ORDER BY column_name, value;


-- 1.5 Players appearing in both versions
-- A player assigned to both gate_30 and gate_40 would contaminate the
-- comparison (assumption A-004).
SELECT COUNT(*) AS players_in_both_versions
FROM (
  SELECT userid
  FROM cookie_cats.raw_cookie_cats
  GROUP BY userid
  HAVING COUNT(DISTINCT version) > 1
);


-- 1.6 Spread of game rounds
-- Run only after 1.3 shows 0 non-integer values: CAST (not SAFE_CAST) is used
-- here so the query fails rather than hiding a bad value.
WITH rounds AS (
  SELECT CAST(sum_gamerounds AS INT64) AS sum_gamerounds
  FROM cookie_cats.raw_cookie_cats
)
SELECT DISTINCT
  MIN(sum_gamerounds)                           OVER () AS min_rounds,
  PERCENTILE_CONT(sum_gamerounds, 0.25)         OVER () AS p25_rounds,
  PERCENTILE_CONT(sum_gamerounds, 0.50)         OVER () AS median_rounds,
  ROUND(AVG(sum_gamerounds)                     OVER (), 2) AS mean_rounds,
  PERCENTILE_CONT(sum_gamerounds, 0.75)         OVER () AS p75_rounds,
  PERCENTILE_CONT(sum_gamerounds, 0.95)         OVER () AS p95_rounds,
  PERCENTILE_CONT(sum_gamerounds, 0.99)         OVER () AS p99_rounds,
  MAX(sum_gamerounds)                           OVER () AS max_rounds,
  COUNTIF(sum_gamerounds = 0)                   OVER () AS zero_round_players
FROM rounds;


-- =============================================================================
-- Section 2 — Investigation
-- =============================================================================

-- Added in step 4: extreme game-round counts and retention flag combinations.


-- =============================================================================
-- Section 3 — Clean Table
-- =============================================================================

-- Added in step 5: CREATE TABLE ... AS SELECT from the raw table, with every
-- change recorded in docs/cleaning_log.md.


-- =============================================================================
-- Section 4 — Validation
-- =============================================================================

-- Added in step 5: row counts and value checks comparing raw and clean tables.


-- =============================================================================
-- Assumptions
-- =============================================================================

-- • The raw table matches the downloaded file (checked by checksum and row
--   count in notebooks/01_data_loading.ipynb).
-- • Assumptions A-003, A-004 and A-005 in docs/assumption_register.md are
--   checked by queries 1.1, 1.5 and 1.4.


-- =============================================================================
-- Limitations
-- =============================================================================

-- • Profiling describes the data as it is. It cannot confirm what the
--   retention flags were defined to mean at the source.


-- =============================================================================
-- Related Documentation
-- =============================================================================

-- README.md
-- PROJECT_INFO.md
-- docs/phase_01_data_preparation.md
-- docs/data_dictionary.md
-- docs/assumption_register.md
-- docs/cleaning_log.md

/*
===============================================================================
End of Script
===============================================================================
*/