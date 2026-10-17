/*
===============================================================================
Project      : Cookie Cats A/B Test
Repository   : cookie-cats-ab-test
Author       : Taofeek Salami
Date Created : 2026-10-15
Last Updated : 2026-10-17

Phase        : Phase 0 - Scoping & Project Setup
Purpose      : Create the BigQuery dataset that holds every project table.
Status       : Complete

Business Question
-----------------
Does moving the first gate from level 30 to level 40 change player retention
among players who installed the game during the test?

Notes
-----
- Run once in the BigQuery console with your own project selected. It does
  the same as: bq --location=US mk --dataset YOUR_PROJECT_ID:cookie_cats
- IF NOT EXISTS makes the script safe to re-run; it changes nothing if the
  dataset already exists.
- Tables are not created here. The raw table is created and replaced by the
  load job in notebooks/01_data_loading.ipynb, which defines its schema, so
  the schema is kept in one place.
===============================================================================
*/


-- =============================================================================
-- Section 1 — Dataset
-- =============================================================================

-- Purpose:
-- Create the dataset (BigQuery's equivalent of a database) in the US location.
-- All tables in the project must be in the same location.

CREATE SCHEMA IF NOT EXISTS cookie_cats
OPTIONS (
  location = 'US',
  description = 'Cookie Cats A/B test: raw and cleaned tables for the gate placement analysis'
);


-- =============================================================================
-- Assumptions
-- =============================================================================

-- • The project runs in the BigQuery sandbox (no billing account linked).


-- =============================================================================
-- Limitations
-- =============================================================================

-- • In the sandbox, tables expire after 60 days. Re-run
--   notebooks/01_data_loading.ipynb to recreate the raw table.


-- =============================================================================
-- Related Documentation
-- =============================================================================

-- README.md
-- PROJECT_INFO.md
-- docs/phase_00_setup.md
-- notebooks/01_data_loading.ipynb

/*
===============================================================================
End of Script
===============================================================================
*/