# ============================================================
# Runs analytical queries against dw_user_analytics
# and saves the results as CSV files in the outputs folder
# ============================================================

from google.cloud import bigquery
import pandas as pd
import os

# ============================================================
# Connect to BigQuery
# ============================================================

client = bigquery.Client(project="core-crossing-479923-k8")

def run_and_save(query_name, query):
    """
    Runs a query against BigQuery and saves
    the results as a CSV file in the outputs folder
    """
    print(f"  Saving {query_name}...", end=" ")
    
    # Run the query and get results as a dataframe
    df = client.query(query).to_dataframe()
    
    # Save to outputs folder as CSV
    output_path = os.path.join("outputs", f"{query_name}.csv")
    df.to_csv(output_path, index=False)
    
    print(f"Done — {len(df):,} rows saved")

print("\n" + "=" * 50)
print("SAVING ANALYTICAL RESULTS TO OUTPUTS FOLDER")
print("=" * 50)

run_and_save(
    "top_10_customers",
    """
    SELECT customer_id, customer_name, total_revenue
    FROM `core-crossing-479923-k8.datapipelin.dw_user_analytics`
    ORDER BY total_revenue DESC
    LIMIT 10
    """
)

run_and_save(
    "customer_segmentation",
    """
    SELECT customer_id, customer_name, total_revenue,
    CASE
        WHEN total_revenue > 5000000 THEN 'High Value'
        WHEN total_revenue > 1000000 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS customer_segment
    FROM `core-crossing-479923-k8.datapipelin.dw_user_analytics`
    ORDER BY total_revenue DESC
    """
)

run_and_save(
    "churn_risk_detection",
    """
    SELECT customer_id, customer_name, total_sessions, total_revenue,
    CASE
        WHEN total_sessions < 5 AND total_revenue < 1000 THEN 'High Risk'
        ELSE 'Active'
    END AS churn_risk
    FROM `core-crossing-479923-k8.datapipelin.dw_user_analytics`
    ORDER BY total_sessions ASC
    """
)

run_and_save(
    "revenue_vs_usage_mismatch",
    """
    SELECT customer_id, customer_name, total_data_used_mb, total_revenue
    FROM `core-crossing-479923-k8.datapipelin.dw_user_analytics`
    WHERE total_data_used_mb > 10000
    AND total_revenue < 500
    ORDER BY total_data_used_mb DESC
    """
)

run_and_save(
    "dw_user_analytics",
    """
    SELECT *
    FROM `core-crossing-479923-k8.datapipelin.dw_user_analytics`
    """
)

print("\n" + "=" * 50)
print("ALL RESULTS SAVED TO OUTPUTS FOLDER")
print("=" * 50)