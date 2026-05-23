# ============================================================
# Runs all stages in the correct order automatically
# ============================================================

from google.cloud import bigquery
import os
import time

# Connect to BigQuery
client = bigquery.Client(project="core-crossing-479923-k8")

def run_sql_file(filepath):
    """
    Reads a SQL file and runs it against BigQuery
    """
    with open(filepath, "r") as f:
        query = f.read()
    client.query(query).result()

def run_stage(stage_name, sql_files):
    """
    Runs all SQL files for a given stage in order
    and prints success or failure for each one
    """
    print(f"\n{'-' * 50}")
    print(f"Running {stage_name}...")
    print(f"{'-' * 50}")
    
    for sql_file in sql_files:
        filename = os.path.basename(sql_file)
        try:
            print(f"  Running {filename}...", end=" ")
            run_sql_file(sql_file)
            print("Done")
        except Exception as e:
            print(f"Failed")
            print(f"  Error: {e}")
            raise

# ============================================================
# PIPELINE STARTS HERE
# ============================================================

print("=" * 50)
print("DATATEL COMMUNICATIONS PIPELINE")
print("=" * 50)
start_time = time.time()

# ============================================================
# Data Ingestion
# ============================================================
print("\nLoading raw data into BigQuery...")
os.system("python3 ingestion/load_data.py")

# ============================================================
# Data Quality Checks
# ============================================================
print("\nRunning data quality checks...")
os.system("python3 validate.py")

# ============================================================
# Staging Layer
# ============================================================
run_stage("Stage 2: Staging Layer", [
    "sql/staging/stg_customers.sql",
    "sql/staging/stg_billing.sql",
    "sql/staging/stg_sessions.sql"
])

# ============================================================
# Transformation Layer
# ============================================================
run_stage("Stage 3: Transformation Layer", [
    "sql/transformations/agg_user_revenue.sql",
    "sql/transformations/agg_user_usage.sql",
    "sql/transformations/agg_monthly_revenue.sql",
    "sql/transformations/agg_arpu.sql",
    "sql/transformations/agg_session_distribution.sql"
])

# ============================================================
# Data Warehouse
# ============================================================
run_stage("Stage 4: Data Warehouse", [
    "sql/warehouse/dw_user_analytics.sql"
])

# ============================================================
# Analytical Queries
# ============================================================
run_stage("Stage 5: Analytical Queries", [
    "sql/analytics/analytical_queries.sql"
])

# ============================================================
# Save Outputs
# ============================================================
print("\nSaving analytical results to outputs folder...")
os.system("python3 scripts/outputs.py")

# ============================================================
# PIPELINE COMPLETE
# ============================================================
end_time = time.time()
duration = round(end_time - start_time, 2)

print("\n" + "=" * 50)
print(f"PIPELINE COMPLETE — Finished in {duration} seconds")
print("=" * 50)