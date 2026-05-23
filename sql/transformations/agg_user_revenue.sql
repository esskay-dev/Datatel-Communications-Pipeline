-- ============================================================
-- Aggregates stg_billing to produce per customer:
--   - total_revenue: sum of all billed amounts
--   - total_transactions: count of all transactions
-- ============================================================

CREATE OR REPLACE TABLE `core-crossing-479923-k8.datapipelin.agg_user_revenue` AS
SELECT
  customer_id,
  SUM(amount) AS total_revenue,
  COUNT(*) AS total_transactions
FROM `core-crossing-479923-k8.datapipelin.stg_billing`
GROUP BY customer_id;