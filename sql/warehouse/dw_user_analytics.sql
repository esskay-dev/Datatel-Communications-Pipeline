CREATE OR REPLACE TABLE `core-crossing-479923-k8.datapipelin.dw_user_analytics` AS
SELECT
  c.customer_id,
  c.customer_name,
  c.email,
  c.country,
  COALESCE(r.total_revenue, 0)            AS total_revenue,
  COALESCE(r.total_transactions, 0)       AS total_transactions,
  COALESCE(u.total_data_used_mb, 0)       AS total_data_used_mb,
  COALESCE(u.avg_session_duration_sec, 0) AS avg_session_duration_sec,
  COALESCE(u.total_sessions, 0)           AS total_sessions,
  COALESCE(a.arpu, 0)                     AS arpu,
  COALESCE(s.short_sessions, 0)           AS short_sessions,
  COALESCE(s.medium_sessions, 0)          AS medium_sessions,
  COALESCE(s.long_sessions, 0)            AS long_sessions,
  CASE
    WHEN COALESCE(u.total_sessions, 0) = 0 THEN 0
    ELSE COALESCE(u.total_data_used_mb, 0) / u.total_sessions
  END AS avg_data_per_session_mb
FROM `core-crossing-479923-k8.datapipelin.stg_customers` c
LEFT JOIN `core-crossing-479923-k8.datapipelin.agg_user_revenue` r
       ON c.customer_id = r.customer_id
LEFT JOIN `core-crossing-479923-k8.datapipelin.agg_user_usage` u
       ON c.customer_id = u.customer_id
LEFT JOIN `core-crossing-479923-k8.datapipelin.agg_arpu` a
       ON c.customer_id = a.customer_id
LEFT JOIN `core-crossing-479923-k8.datapipelin.agg_session_distribution` s
       ON c.customer_id = s.customer_id;