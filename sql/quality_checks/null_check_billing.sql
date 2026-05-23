-- ============================================================
-- Null Check: src_billing_transactions
-- Returns any records where transaction_id or customer_id is NULL
-- ============================================================

SELECT *
FROM `core-crossing-479923-k8.datapipelin.src_billing_transactions`
WHERE transaction_id IS NULL
   OR customer_id IS NULL;
