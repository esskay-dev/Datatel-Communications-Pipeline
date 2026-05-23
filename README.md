# Automated Telecom Data Pipeline
### Data Engineering Capstone Project

---

## Project Overview

This project builds a full end-to-end data pipeline for **DataTel Communications**, a mid-sized telecom operator serving customers across Nigeria.

DataTel collects millions of records daily across three separate operational systems — a Billing System, a Network System, and a CRM System. These systems operate independently and store data in their own structure with their own problems: missing values, inconsistent formatting, duplicate records caused by system retries, and dates stored as plain text instead of proper date types.

The pipeline consolidates data from all three systems into a centralised data warehouse that powers three key business use cases:
- **Customer analytics:** identifying the most valuable users and understanding how they engage with the network
- **Churn risk detection:** flagging customers who are becoming inactive before they cancel their subscriptions
- **Revenue operations:** surfacing mismatches between how much data customers consume and how much they pay

The pipeline is built entirely using **SQL on Google BigQuery** and follows a classic multi-stage architecture where each stage has a single responsibility — making the pipeline easier to test, debug, and extend.

---

## Pipeline Architecture

| Stage | Description | Output |
|-------|-------------|--------|
| Stage 1 | Data Quality Checks: detect nulls and duplicates in raw data before anything moves | Validation reports |
| Stage 2 | Staging Layer: clean, cast, and deduplicate source tables | `stg_billing`, `stg_sessions`, `stg_customers` |
| Stage 3 | Transformation Layer: aggregate metrics per customer | `agg_user_revenue`, `agg_user_usage`, `agg_monthly_revenue`, `agg_arpu`, `agg_session_distribution` |
| Stage 4 | Data Warehouse: join all tables into one unified analytics table | `dw_user_analytics` |
| Stage 5 | Analytical Queries: answer real business questions from the warehouse | Query results |
| Stage 6 | Incremental Load: append only new records on each pipeline run instead of rebuilding from scratch | Updated `stg_billing` |

---

## Source Data

Three raw source tables were loaded into BigQuery. These represent data exactly as it arrives from the operational systems — unvalidated, unformatted, and not yet fit for analysis:

- **src_billing_transactions:** 1.5 million billing records containing one row per billing event. Includes intentional duplicate transaction IDs caused by system retries, and null values for failed transactions where no amount was recorded.

- **src_network_sessions:** 3 million network session records containing one row per data session. Includes intentional duplicate session IDs caused by logging retries, invalid timestamps where end time appears before start time due to clock synchronisation errors, and null values for interrupted sessions.

- **src_customers:** 100,000 customer profiles containing one row per registered customer. Includes inconsistent name capitalisation (e.g. 'AMINU SULE', 'fatima bello'), mixed case emails, and missing country values for older records migrated from a legacy system.

---

## Tools Used

- **Google BigQuery:** the cloud-based data warehouse where all 13 tables were created and all SQL queries were written and executed throughout the project.

- **Google Cloud Shell:** the browser-based terminal inside Google Cloud that was used to run the data generation script and upload the three source CSV files into BigQuery using the `bq load` command.

- **Python:** the provided `data_generator.py` script was run to generate the source CSV files. The script used the pandas library to organise the data, faker to produce realistic names and emails, and tqdm to display progress bars during generation.

- **Git & GitHub:** Git was used in the Mac terminal to track all project files and commit changes. GitHub was used to host the project online, making the code publicly accessible and professionally presented.

---

## Key SQL Concepts Used

- `ROW_NUMBER() OVER (PARTITION BY ...)`: a window function used for deduplication. It assigns a rank to each row within a group of duplicate IDs, allowing only the most recent version to be kept by filtering on rank 1.

- `COALESCE()`: used for null value handling. Returns the first non-null value in its arguments — for example, COALESCE(amount, 0) replaces any null amount with zero so arithmetic operations don't fail.

- `CAST()`: used for type conversion. Converts transaction dates and session timestamps from plain text strings into proper TIMESTAMP types that BigQuery can sort, filter, and calculate with.

- `DATE_TRUNC()`: used for monthly revenue aggregation. Truncates a full timestamp down to the first day of its month, making it easy to group all transactions in the same month together.

- `NULLIF()`: used for divide-by-zero protection in the ARPU calculation. Returns NULL instead of zero when the denominator is zero, preventing the query from crashing with a division error.

- `LEFT JOIN`: used in the data warehouse table to preserve every customer in the output regardless of whether they have billing or session records. An INNER JOIN would silently drop customers with no activity.

- **Incremental loading using scalar subqueries:** instead of rebuilding the staging table from scratch on every pipeline run, a scalar subquery dynamically retrieves the most recent timestamp already loaded and only inserts records newer than that — making the pipeline faster and more efficient as data volumes grow.
