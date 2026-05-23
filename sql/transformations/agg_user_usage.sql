-- ============================================================
-- Aggregates stg_sessions to produce per customer:
--   - total_data_used_mb: total megabytes consumed
--   - avg_session_duration_sec: average session length in seconds
--   - total_sessions: count of all sessions
-- ============================================================

CREATE OR REPLACE TABLE `core-crossing-479923-k8.datapipelin.agg_user_usage` AS
SELECT
  customer_id,
  SUM(data_used_mb) AS total_data_used_mb,
  AVG(session_duration_sec) AS avg_session_duration_sec,
  COUNT(*) AS total_sessions
FROM `core-crossing-479923-k8.datapipelin.stg_sessions`
GROUP BY customer_id;