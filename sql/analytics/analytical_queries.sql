-- ------------------------------------------------------------
-- All queries run against dw_user_analytics
-- ------------------------------------------------------------

------------------------------------------------------------
-- Query 1: Top 10 Customers by Revenue
-- Returns the highest spending customers, ranked highest first
-- ------------------------------------------------------------

SELECT
  customer_id,
  customer_name,
  total_revenue
FROM `core-crossing-479923-k8.datapipelin.dw_user_analytics`
ORDER BY total_revenue DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Query 2: Customer Segmentation
-- Labels each customer based on their total lifetime revenue
-- ------------------------------------------------------------

SELECT
  customer_id,
  customer_name,
  total_revenue,
  CASE
    WHEN total_revenue > 5000000 THEN 'High Value'
    WHEN total_revenue > 1000000 THEN 'Mid Value'
    ELSE 'Low Value'
  END AS customer_segment
FROM `core-crossing-479923-k8.datapipelin.dw_user_analytics`
ORDER BY total_revenue DESC;

-- ------------------------------------------------------------
-- Query 3: Churn Risk Detection
-- Flags customers with fewer than 5 sessions AND less than
-- 1,000 in total revenue as High Risk
-- ------------------------------------------------------------

SELECT
  customer_id,
  customer_name,
  total_sessions,
  total_revenue,
  CASE
    WHEN total_sessions < 5 AND total_revenue < 1000 THEN 'High Risk'
    ELSE 'Active'
  END AS churn_risk
FROM `core-crossing-479923-k8.datapipelin.dw_user_analytics`
ORDER BY total_sessions ASC;

-- ------------------------------------------------------------
-- Query 4: Revenue vs Usage Mismatch
-- Finds customers consuming more than 10,000 MB of data
-- but generating less than 500 in revenue
-- ------------------------------------------------------------

SELECT
  customer_id,
  customer_name,
  total_data_used_mb,
  total_revenue
FROM `core-crossing-479923-k8.datapipelin.dw_user_analytics`
WHERE total_data_used_mb > 10000
  AND total_revenue < 500
ORDER BY total_data_used_mb DESC;