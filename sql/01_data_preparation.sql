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

-- Purpose:
-- Look into the unusual values found in Section 1 before deciding anything:
-- the very high game-round counts, the players with 0 rounds, and how the two
-- retention flags combine. Section 1 showed every value converts cleanly, so
-- CAST is used. Nothing is changed in this section.


-- 2.1 The 10 highest game-round counts
-- Shows whether the maximum is one isolated player or part of a group, and
-- how big the gap is between the highest values.
SELECT
  userid,
  version,
  CAST(sum_gamerounds AS INT64) AS sum_gamerounds,
  retention_1,
  retention_7
FROM cookie_cats.raw_cookie_cats
ORDER BY sum_gamerounds DESC
LIMIT 10;


-- 2.2 How many players sit above several thresholds
-- 493 is the 99th percentile from query 1.6. The higher thresholds show how
-- thin the far tail is.
SELECT
  COUNTIF(CAST(sum_gamerounds AS INT64) > 493)   AS above_p99_493,
  COUNTIF(CAST(sum_gamerounds AS INT64) > 1000)  AS above_1000,
  COUNTIF(CAST(sum_gamerounds AS INT64) > 2500)  AS above_2500,
  COUNTIF(CAST(sum_gamerounds AS INT64) > 5000)  AS above_5000,
  COUNTIF(CAST(sum_gamerounds AS INT64) > 10000) AS above_10000
FROM cookie_cats.raw_cookie_cats;


-- 2.3 Retention flags for players with 0 game rounds
-- If retention means "came back and played", a player with 0 rounds who is
-- marked as retained would need explaining.
SELECT
  retention_1,
  retention_7,
  COUNT(*) AS players
FROM cookie_cats.raw_cookie_cats
WHERE CAST(sum_gamerounds AS INT64) = 0
GROUP BY retention_1, retention_7
ORDER BY retention_1, retention_7;


-- 2.4 All four combinations of the two retention flags (all players)
-- Counts players retained at day 7 but not at day 1, and the other
-- combinations. The query shows how common each is; it cannot show why.
SELECT
  retention_1,
  retention_7,
  COUNT(*)                                     AS players,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_players
FROM cookie_cats.raw_cookie_cats
GROUP BY retention_1, retention_7
ORDER BY retention_1, retention_7;

-- =============================================================================
-- Section 3 — Clean Table
-- =============================================================================

-- Purpose:
-- Build cookie_cats.clean_cookie_cats from the raw table. Every row is kept.
-- Changes (each recorded in docs/cleaning_log.md):
--   1. userid and sum_gamerounds converted from text to INT64.
--   2. retention_1 and retention_7 converted from 'TRUE'/'FALSE' text to BOOL.
--   3. Two flag columns added for the Phase 3 sensitivity check:
--      is_extreme_gamerounds marks sum_gamerounds above 10,000 (one player;
--      the threshold sits in the gap between 2,961 and 49,854, query 2.1).
--      is_zero_gamerounds marks players with 0 game rounds (query 1.6).
-- CAST is safe here because queries 1.3 and 1.4 found no values that fail to
-- convert. If the raw data ever changed, CAST would stop the query instead of
-- silently producing NULLs.
-- CREATE OR REPLACE makes the script safe to re-run.

CREATE OR REPLACE TABLE cookie_cats.clean_cookie_cats AS
SELECT
  CAST(userid AS INT64)          AS userid,
  version,
  CAST(sum_gamerounds AS INT64)  AS sum_gamerounds,
  CAST(retention_1 AS BOOL)      AS retention_1,
  CAST(retention_7 AS BOOL)      AS retention_7,
  CAST(sum_gamerounds AS INT64) > 10000 AS is_extreme_gamerounds,
  CAST(sum_gamerounds AS INT64) = 0     AS is_zero_gamerounds
FROM cookie_cats.raw_cookie_cats;

-- =============================================================================
-- Section 4 — Validation
-- =============================================================================

-- Purpose:
-- Confirm the clean table differs from the raw table only in the ways recorded
-- in the cleaning log: same rows, same totals, correct types, expected flags.


-- 4.1 Reconcile raw and clean
-- Each pair of columns should match, and every *_match column should be true.
WITH raw AS (
  SELECT
    COUNT(*)                            AS row_count,
    COUNT(DISTINCT userid)              AS distinct_userids,
    COUNTIF(version = 'gate_30')        AS gate_30_players,
    COUNTIF(version = 'gate_40')        AS gate_40_players,
    COUNTIF(retention_1 = 'TRUE')       AS retained_day_1,
    COUNTIF(retention_7 = 'TRUE')       AS retained_day_7,
    SUM(CAST(sum_gamerounds AS INT64))  AS total_gamerounds
  FROM cookie_cats.raw_cookie_cats
),
clean AS (
  SELECT
    COUNT(*)                     AS row_count,
    COUNT(DISTINCT userid)       AS distinct_userids,
    COUNTIF(version = 'gate_30') AS gate_30_players,
    COUNTIF(version = 'gate_40') AS gate_40_players,
    COUNTIF(retention_1)         AS retained_day_1,
    COUNTIF(retention_7)         AS retained_day_7,
    SUM(sum_gamerounds)          AS total_gamerounds
  FROM cookie_cats.clean_cookie_cats
)
SELECT
  raw.row_count,        clean.row_count        AS clean_row_count,        raw.row_count        = clean.row_count        AS rows_match,
  raw.distinct_userids, clean.distinct_userids AS clean_distinct_userids, raw.distinct_userids = clean.distinct_userids AS ids_match,
  raw.gate_30_players,  clean.gate_30_players  AS clean_gate_30_players,  raw.gate_30_players  = clean.gate_30_players  AS gate_30_match,
  raw.gate_40_players,  clean.gate_40_players  AS clean_gate_40_players,  raw.gate_40_players  = clean.gate_40_players  AS gate_40_match,
  raw.retained_day_1,   clean.retained_day_1   AS clean_retained_day_1,   raw.retained_day_1   = clean.retained_day_1   AS day_1_match,
  raw.retained_day_7,   clean.retained_day_7   AS clean_retained_day_7,   raw.retained_day_7   = clean.retained_day_7   AS day_7_match,
  raw.total_gamerounds, clean.total_gamerounds AS clean_total_gamerounds, raw.total_gamerounds = clean.total_gamerounds AS rounds_match
FROM raw CROSS JOIN clean;


-- 4.2 Column types in the clean table
-- INFORMATION_SCHEMA holds BigQuery's own description of each table.
-- Expected: userid INT64, version STRING, sum_gamerounds INT64,
-- retention_1 BOOL, retention_7 BOOL, both flags BOOL.
SELECT column_name, data_type
FROM cookie_cats.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'clean_cookie_cats'
ORDER BY ordinal_position;


-- 4.3 No NULLs introduced, and flag counts as expected
-- Expected: all null counts 0, extreme_flagged 1, zero_flagged 3,994.
SELECT
  COUNTIF(userid IS NULL)          AS null_userid,
  COUNTIF(version IS NULL)         AS null_version,
  COUNTIF(sum_gamerounds IS NULL)  AS null_sum_gamerounds,
  COUNTIF(retention_1 IS NULL)     AS null_retention_1,
  COUNTIF(retention_7 IS NULL)     AS null_retention_7,
  COUNTIF(is_extreme_gamerounds)   AS extreme_flagged,
  COUNTIF(is_zero_gamerounds)      AS zero_flagged
FROM cookie_cats.clean_cookie_cats;

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