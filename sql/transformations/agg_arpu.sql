-- ============================================================
-- Calculates ARPU per customer:
--   ARPU = total revenue / number of distinct active months
-- ============================================================

CREATE OR REPLACE TABLE `core-crossing-479923-k8.datapipelin.agg_arpu` AS
SELECT
  customer_id,
  SUM(monthly_revenue) AS total_revenue,
  COUNT(DISTINCT month) AS active_months,
  SUM(monthly_revenue) / NULLIF(COUNT(DISTINCT month), 0) AS arpu
FROM `core-crossing-479923-k8.datapipelin.agg_monthly_revenue`
GROUP BY customer_id;