from google.cloud import bigquery
import os

# Connect to BigQuery
client = bigquery.Client(project="core-crossing-479923-k8")

def run_check(name, sql_file):
    """
    Reads a SQL file, runs it against BigQuery,
    and prints how many problem rows were found
    """
    print(f"\nRunning {name}...")
    
    # Open and read the SQL file
    with open(sql_file, "r") as f:
        query = f.read()
    
    # Send the query to BigQuery and get results
    results = client.query(query).result()
    
    # Count how many rows came back
    rows = list(results)
    count = len(rows)
    
    if count == 0:
        print(f"No issues found")
    else:
        print(f"{count} problem rows found")

# ============================================================
# Run all quality checks
# ============================================================

print("=" * 50)
print("DATATEL PIPELINE — DATA QUALITY REPORT")
print("=" * 50)

run_check(
    "Null Check: src_billing_transactions",
    "sql/quality_checks/null_check_billing.sql"
)

run_check(
    "Null Check: src_network_sessions",
    "sql/quality_checks/null_check_sessions.sql"
)

run_check(
    "Duplicate Check: src_billing_transactions",
    "sql/quality_checks/duplicate_check_billing.sql"
)

run_check(
    "Duplicate Check: src_network_sessions",
    "sql/quality_checks/duplicate_check_sessions.sql"
)

print("\n" + "=" * 50)
print("QUALITY CHECKS COMPLETE")
print("=" * 50)