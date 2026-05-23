-- ============================================================
-- Cleans src_network_sessions:
--   1. Removes duplicate session_ids (keeps most recent)
--   2. Casts start_time and end_time from text to TIMESTAMP
--   3. Replaces NULL data_used_mb with zero
--   4. Calculates session_duration_sec
--   5. Sets duration to zero where end_time <= start_time
-- ============================================================

CREATE OR REPLACE TABLE `core-crossing-479923-k8.datapipelin.stg_sessions` AS
WITH ranked AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY session_id
      ORDER BY start_time DESC
    ) AS row_num
  FROM `core-crossing-479923-k8.datapipelin.src_network_sessions`
)
SELECT
  session_id,
  customer_id,
  CAST(start_time AS TIMESTAMP) AS start_time,
  CAST(end_time AS TIMESTAMP) AS end_time,
  COALESCE(data_used_mb, 0) AS data_used_mb,
  CASE
    WHEN CAST(end_time AS TIMESTAMP) > CAST(start_time AS TIMESTAMP)
    THEN TIMESTAMP_DIFF(
           CAST(end_time AS TIMESTAMP),
           CAST(start_time AS TIMESTAMP),
           SECOND
         )
    ELSE 0
  END AS session_duration_sec
FROM ranked
WHERE row_num = 1;