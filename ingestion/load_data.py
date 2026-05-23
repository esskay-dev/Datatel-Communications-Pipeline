from google.cloud import bigquery
import pandas as pd
import os

# Connect to BigQuery
client = bigquery.Client(project="core-crossing-479923-k8")

# Name of the dataset where raw tables will be stored
DATASET = "datapipelin"

def load_csv_to_bigquery(filename, table_name):
    """
    Reads a CSV file and loads it into BigQuery as a table
    """
    filepath = os.path.join("raw_data", filename)
    
    print(f"Loading {filename} into {table_name}...", end=" ")
    
    # Read the CSV file into a pandas dataframe
    df = pd.read_csv(filepath)
    
    # The full table ID in the format: project.dataset.table
    table_id = f"core-crossing-479923-k8.{DATASET}.{table_name}"
    
    # Load the dataframe into BigQuery
    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_TRUNCATE"
    )
    
    job = client.load_table_from_dataframe(
        df, table_id, job_config=job_config
    )
    job.result()
    
    print(f"Done — {len(df):,} rows loaded")

# Load all three source tables

print("=" * 50)
print("DATATEL PIPELINE — DATA INGESTION")
print("=" * 50)

load_csv_to_bigquery(
    "src_customers.csv",
    "src_customers"
)

load_csv_to_bigquery(
    "src_billing_transactions.csv",
    "src_billing_transactions"
)

load_csv_to_bigquery(
    "src_network_sessions.csv",
    "src_network_sessions"
)

print("\n" + "=" * 50)
print("INGESTION COMPLETE — All source tables loaded")
print("=" * 50)