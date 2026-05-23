-- ============================================================
-- Duplicate Check: src_network_sessions
-- Returns session_ids that appear more than once
-- ============================================================

SELECT
    session_id,
    COUNT(*) AS occurrences
FROM `core-crossing-479923-k8.datapipelin.src_network_sessions`
GROUP BY session_id
HAVING COUNT(*) > 1;