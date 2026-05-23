-- ============================================================
-- Null Check: src_network_sessions
-- Returns any records where session_id or customer_id is NULL
-- ============================================================

SELECT *
FROM `core-crossing-479923-k8.datapipelin.src_network_sessions`
WHERE session_id IS NULL
   OR customer_id IS NULL;