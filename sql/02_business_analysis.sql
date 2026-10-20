/*
===============================================================================
Project      : Cookie Cats A/B Test
Repository   : cookie-cats-ab-test
Author       : Taofeek Salami
Date Created : 2026-10-15
Last Updated : 2026-10-20

Phase        : Phase 2 - Business Analysis
Purpose      : Check the group split, then describe retention and game rounds by version.
Status       : In progress

Business Question
-----------------
Does moving the first gate from level 30 to level 40 change player retention
among players who installed the game during the test?

Notes
-----
- Runs against cookie_cats.clean_cookie_cats (built in sql/01_data_preparation.sql, Section 3).
- Descriptive only. No p-values or confidence intervals for retention or game
  rounds; those belong to Phase 4.
- Query 2.0 is run, and the sample ratio test in notebooks/03_business_analysis.ipynb
  is passed, before the results of queries 2.1 onwards are read.
===============================================================================
*/

-- =============================================================================
-- Section 0 — Sample ratio check
-- =============================================================================

-- 2.0 How many players were assigned to each version, and how does that
--     compare with the 50/50 split assumed in the charter (A-009)?
-- The chi-square test runs in notebooks/03_business_analysis.ipynb, because
-- BigQuery has no function that returns a chi-square p-value.
SELECT
  version,
  COUNT(*) AS players,
  -- SUM(COUNT(*)) OVER () adds up the per-version counts after GROUP BY,
  -- giving the total number of players on every row.
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER (), 4) AS share_of_players,
  -- Number of players each version would have under an exact 50/50 split.
  SUM(COUNT(*)) OVER () / 2 AS expected_players
FROM cookie_cats.clean_cookie_cats
GROUP BY version
ORDER BY version;

-- =============================================================================
-- Section 1 — Retention by version
-- =============================================================================

-- 2.1 How many players were retained at day 1 and day 7 in each version?
-- Casting a BOOL to INT64 turns TRUE into 1 and FALSE into 0, so the average is
-- the share of players retained.
SELECT
  version,
  COUNT(*)                                          AS players,
  COUNTIF(retention_1)                              AS retained_day1,
  ROUND(100 * AVG(CAST(retention_1 AS INT64)), 2)   AS retention_1_pct,
  COUNTIF(retention_7)                              AS retained_day7,
  ROUND(100 * AVG(CAST(retention_7 AS INT64)), 2)   AS retention_7_pct
FROM cookie_cats.clean_cookie_cats
GROUP BY version
ORDER BY version;

-- 2.2 How large is the retention gap between versions (gate_40 − gate_30)?
-- AVG skips NULLs, so IF(version = ..., value, NULL) averages one version only.
-- gap_pp is in percentage points; relative_gap_pct is the gap as a percentage
-- of the gate_30 rate. Descriptive only: no significance test here.
WITH rates AS (
  SELECT
    AVG(IF(version = 'gate_30', CAST(retention_1 AS INT64), NULL)) AS r1_30,
    AVG(IF(version = 'gate_40', CAST(retention_1 AS INT64), NULL)) AS r1_40,
    AVG(IF(version = 'gate_30', CAST(retention_7 AS INT64), NULL)) AS r7_30,
    AVG(IF(version = 'gate_40', CAST(retention_7 AS INT64), NULL)) AS r7_40
  FROM cookie_cats.clean_cookie_cats
)
SELECT
  '1-day retention'                                  AS metric,
  ROUND(100 * r1_30, 2)                              AS gate_30_pct,
  ROUND(100 * r1_40, 2)                              AS gate_40_pct,
  ROUND(100 * (r1_40 - r1_30), 2)                    AS gap_pp,
  ROUND(100 * (r1_40 - r1_30) / r1_30, 2)            AS relative_gap_pct
FROM rates
UNION ALL
SELECT
  '7-day retention',
  ROUND(100 * r7_30, 2),
  ROUND(100 * r7_40, 2),
  ROUND(100 * (r7_40 - r7_30), 2),
  ROUND(100 * (r7_40 - r7_30) / r7_30, 2)
FROM rates;

-- =============================================================================
-- Section 2 — Game rounds by version (guardrail, exploratory)
-- =============================================================================

-- 2.3 How do game rounds compare between versions?
-- The median and quartiles describe the typical player; the mean is shown with
-- and without the one flagged extreme player (is_extreme_gamerounds), because a
-- single value of 49,854 moves the gate_30 mean.
WITH quartiles AS (
  SELECT DISTINCT
    version,
    PERCENTILE_CONT(sum_gamerounds, 0.25) OVER (PARTITION BY version) AS p25_rounds,
    PERCENTILE_CONT(sum_gamerounds, 0.50) OVER (PARTITION BY version) AS median_rounds,
    PERCENTILE_CONT(sum_gamerounds, 0.75) OVER (PARTITION BY version) AS p75_rounds
  FROM cookie_cats.clean_cookie_cats
),
summary AS (
  SELECT
    version,
    COUNT(*)                                                         AS players,
    SUM(sum_gamerounds)                                              AS total_rounds,
    ROUND(AVG(sum_gamerounds), 2)                                    AS mean_rounds,
    ROUND(AVG(IF(NOT is_extreme_gamerounds, sum_gamerounds, NULL)), 2) AS mean_rounds_excl_extreme,
    MAX(sum_gamerounds)                                              AS max_rounds,
    ROUND(100 * COUNTIF(is_zero_gamerounds) / COUNT(*), 2)           AS zero_rounds_pct
  FROM cookie_cats.clean_cookie_cats
  GROUP BY version
)
SELECT
  s.version, s.players, s.total_rounds,
  q.p25_rounds, q.median_rounds, q.p75_rounds,
  s.mean_rounds, s.mean_rounds_excl_extreme, s.max_rounds, s.zero_rounds_pct
FROM summary AS s
JOIN quartiles AS q USING (version)
ORDER BY s.version;

-- =============================================================================
-- Section 3 — Retention patterns by version
-- =============================================================================

-- 2.4 What share of each version was retained on neither day, day 1 only,
--     day 7 only, or both days?
-- The window SUM with PARTITION BY version gives each version's own total, so
-- percentages add up to 100 within each version.
SELECT
  version,
  CASE
    WHEN retention_1 AND retention_7 THEN 'Both days'
    WHEN retention_1                 THEN 'Day 1 only'
    WHEN retention_7                 THEN 'Day 7 only'
    ELSE 'Neither'
  END                                                                    AS retention_pattern,
  COUNT(*)                                                               AS players,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY version), 2)   AS pct_of_version
FROM cookie_cats.clean_cookie_cats
GROUP BY version, retention_pattern
ORDER BY retention_pattern, version;