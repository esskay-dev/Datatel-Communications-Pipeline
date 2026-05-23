-- ============================================================
-- Cleans src_billing_transactions:
--   1. Removes duplicate transaction_ids (keeps most recent)
--   2. Replaces NULL amounts with zero
--   3. Casts transaction_date from text to TIMESTAMP
-- ============================================================

CREATE OR REPLACE TABLE `core-crossing-479923-k8.datapipelin.stg_billing` AS
WITH ranked AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY transaction_id
      ORDER BY transaction_date DESC
    ) AS row_num
  FROM `core-crossing-479923-k8.datapipelin.src_billing_transactions`
)
SELECT
  transaction_id,
  customer_id,
  COALESCE(amount, 0) AS amount,
  CAST(transaction_date AS TIMESTAMP) AS transaction_ts
FROM ranked
WHERE row_num = 1;