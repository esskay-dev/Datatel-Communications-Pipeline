## Project Overview

DataTel Communications generates millions of records every day across three disconnected operational systems. Each system stores data independently with no shared structure, no common formatting, and no way to connect a customer's billing history to their network usage or their profile. The business lacks insights into its most valuable customers, early signs of churn, and customers consuming far more than they pay for.

---

## What This Pipeline Does

In a single command:

```bash
python3 main.py
```

The pipeline automatically:
- Loads 4.6 million raw records into Google BigQuery
- Runs data quality checks and surfaces any problems before they corrupt downstream data
- Cleans, deduplicates, and standardises all three source tables
- Builds aggregated business metrics per customer
- Joins everything into one unified analytics table
- Saves four business-ready analytical reports as CSV files

---

## Data Flow Architecture

The pipeline follows a layered transformation model where each layer has one job and passes clean outputs to the next:

```
[Raw CSV Files on Local Disk]
          │
          ▼  ingestion/load_data.py
┌─────────────────────────────────────────────────────┐
│               GOOGLE BIGQUERY                       │
│                                                     │
│  ── SOURCE LAYER (Raw) ──────────────────────────   │
│  src_customers                                      │
│  src_billing_transactions                           │
│  src_network_sessions                               │
│            │                                        │
│            ▼  sql/staging/                          │
│  ── STAGING LAYER (Clean) ───────────────────────   │
│  stg_customers     → name fixed, email lowercased   │
│  stg_billing       → deduplicated, nulls filled     │
│  stg_sessions      → duration calculated, cast      │
│            │                                        │
│            ▼  sql/transformations/                  │
│  ── METRICS LAYER (Aggregated) ──────────────────   │
│  agg_user_revenue                                   │
│  agg_user_usage                                     │
│  agg_monthly_revenue                                │
│  agg_arpu                                           │
│  agg_session_distribution                           │
│            │                                        │
│            ▼  sql/warehouse/                        │
│  ── WAREHOUSE LAYER (Unified) ───────────────────   │
│  dw_user_analytics  ← single source of truth       │
│            │                                        │
│            ▼  sql/analytics/                        │
│  ── ANALYTICS LAYER (Business Insights) ─────────   │
│  Top customers, churn risk, segmentation, mismatch  │
└─────────────────────────────────────────────────────┘
          │
          ▼  scripts/outputs.py
[CSV Reports saved to outputs/ folder]
```

---

## Project Structure

```
Datatel-Communications-Pipeline/
├── main.py                    ← runs the entire pipeline in one command
├── validate.py                ← data quality checks before any transformation
├── requirements.txt           ← all Python libraries needed
├── .gitignore                 ← keeps secrets and large files off GitHub
│
├── ingestion/
│   └── load_data.py           ← loads raw CSV files into BigQuery source tables
│
├── scripts/
│   └── outputs.py             ← runs analytical queries and saves results as CSV
│
├── sql/
│   ├── quality_checks/        ← null and duplicate detection queries
│   ├── staging/               ← cleaning and deduplication transformations
│   ├── transformations/       ← business metric aggregations
│   ├── warehouse/             ← final unified analytics table
│   └── analytics/             ← business intelligence queries
│
├── outputs/                   ← analytical results saved here as CSV files
│   ├── top_10_customers.csv
│   ├── customer_segmentation.csv
│   ├── churn_risk_detection.csv
│   ├── revenue_vs_usage_mismatch.csv
│   └── dw_user_analytics.csv
│
└── raw_data/                  ← raw CSV files (excluded from GitHub; too large)
```

---

## Getting Started

### Prerequisites
- Python 3.10 or higher
- Google Cloud account with BigQuery access
- Google Cloud SDK installed and authenticated

### 1. Clone the repository
```bash
git clone https://github.com/esskay-dev/Datatel-Communications-Pipeline.git
cd Datatel-Communications-Pipeline
```

### 2. Install dependencies
```bash
pip3 install -r requirements.txt
```

### 3. Authenticate with Google Cloud
```bash
gcloud auth application-default login
```

### 4. Run the pipeline
```bash
python3 main.py
```

---

## Source Data

| Table | Rows | Known Issues |
|-------|------|--------------|
| src_customers | 100,000 | Inconsistent name capitalisation, missing country values |
| src_billing_transactions | 1,530,000 | 30,000 duplicate transaction IDs, null amounts |
| src_network_sessions | 3,060,000 | 60,000 duplicate session IDs, invalid timestamps |

---

## Tools Used

- **Google BigQuery:** cloud data warehouse where all 13 tables live and all SQL runs
- **Python 3:** pipeline orchestration; connects to BigQuery, reads SQL files, and runs them in order
- **Google Cloud SDK:** authenticates Python to BigQuery from the local Mac terminal
- **Git & GitHub:** version control and public project hosting
