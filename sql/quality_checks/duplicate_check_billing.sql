-- ============================================================
-- Duplicate Check: src_billing_transactions
-- Returns transaction_ids that appear more than once
-- ============================================================

SELECT
    transaction_id,
    COUNT(*) AS occurrences
FROM `core-crossing-479923-k8.datapipelin.src_billing_transactions`
GROUP BY transaction_id
HAVING COUNT(*) > 1;