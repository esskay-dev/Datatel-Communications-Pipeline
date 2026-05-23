-- ============================================================
-- This is a two step process:
--
-- Step 1: session_buckets
-- Labels every session with a type based on its duration:
--   short  = under 60 seconds
--   medium = between 60 and 299 seconds
--   long   = 300 seconds or more
--
-- Step 2: agg_session_distribution
-- Counts short, medium and long sessions per customer
-- ============================================================

-- Step 1: Create session buckets
CREATE OR REPLACE TABLE `core-crossing-479923-k8.datapipelin.session_buckets` AS
SELECT
  session_id,
  customer_id,
  session_duration_sec,
  CASE
    WHEN session_duration_sec < 60 THEN 'short'
    WHEN session_duration_sec < 300 THEN 'medium'
    ELSE 'long'
  END AS session_type
FROM `core-crossing-479923-k8.datapipelin.stg_sessions`;

-- Step 2: Aggregate session counts per customer
CREATE OR REPLACE TABLE `core-crossing-479923-k8.datapipelin.agg_session_distribution` AS
SELECT
  customer_id,
  COUNTIF(session_type = 'short') AS short_sessions,
  COUNTIF(session_type = 'medium') AS medium_sessions,
  COUNTIF(session_type = 'long') AS long_sessions
FROM `core-crossing-479923-k8.datapipelin.session_buckets`
GROUP BY customer_id;