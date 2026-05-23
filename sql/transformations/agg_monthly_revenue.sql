-- ============================================================
-- Shows each customer's revenue broken down by calendar month.
-- DATE_TRUNC truncates timestamps to the first day of each month
-- ============================================================

CREATE OR REPLACE TABLE `core-crossing-479923-k8.datapipelin.agg_monthly_revenue` AS
SELECT
  customer_id,
  DATE_TRUNC(transaction_ts, MONTH) AS month,
  SUM(amount) AS monthly_revenue
FROM `core-crossing-479923-k8.datapipelin.stg_billing`
GROUP BY customer_id, DATE_TRUNC(transaction_ts, MONTH);