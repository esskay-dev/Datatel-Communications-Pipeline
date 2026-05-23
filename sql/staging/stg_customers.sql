-- ============================================================
-- Cleans src_customers:
--   1. Standardises name capitalisation using INITCAP
--   2. Converts email to lowercase using LOWER
--   3. Fills NULL country values with 'Nigeria'
--   4. Casts created_at from text to TIMESTAMP
-- ============================================================

CREATE OR REPLACE TABLE `core-crossing-479923-k8.datapipelin.stg_customers` AS
SELECT
  customer_id,
  INITCAP(name) AS customer_name,
  LOWER(email) AS email,
  COALESCE(country, 'Nigeria') AS country,
  CAST(created_at AS TIMESTAMP) AS created_at
FROM `core-crossing-479923-k8.datapipelin.src_customers`;