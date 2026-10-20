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