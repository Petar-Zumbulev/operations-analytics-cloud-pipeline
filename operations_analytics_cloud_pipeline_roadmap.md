# Operations Analytics & Cloud Data Pipeline Prep

## GitHub Repo Name

``` text
operations-analytics-cloud-pipeline
```

## One-line Portfolio Description

A realistic Python, SQL, and AWS-oriented analytics engineering project that simulates messy operations / marketplace / e-commerce data, performs schema validation and data quality checks, cleans and quarantines problematic records, loads processed fact and dimension tables into a SQL database, produces KPI reports, builds a forecasting/predictive modeling component, and documents how the workflow maps to a simple cloud analytics architecture.

------------------------------------------------------------------------

# 1. Why this project exists

The previous R-focused analytics project built a strong foundation in R, tidyverse, Shiny, Excel/reporting workflows, SQL basics, Git, and interview explanations. This new project broadens the profile toward:

-   data analyst
-   business intelligence analyst
-   analytics engineer
-   junior data engineer
-   operations analyst
-   marketplace / product analyst
-   applied data scientist
-   future AI/data engineering roles

The strategic focus is **operations analytics** using a marketplace/e-commerce case study. This is broad enough for many employers, but concrete enough to create realistic business logic, messy data issues, KPI definitions, SQL tables, and forecasting/predictive modeling tasks.

The project is designed to answer this portfolio story:

> “I built a realistic operations analytics and cloud-style data pipeline using Python, SQL, and AWS basics. The project starts from messy raw marketplace/e-commerce data, performs schema validation and data quality checks, cleans and quarantines problematic records, loads processed fact and dimension tables into a SQL database, produces KPI reports, builds a forecasting/predictive modeling component, and documents how the workflow maps to a simple AWS/S3 cloud analytics architecture.”

------------------------------------------------------------------------

# 2. Positioning

## Main positioning

> This is an operations analytics and cloud data pipeline project using a marketplace/e-commerce business case.

This positioning makes the project relevant to many job families:

-   data analytics
-   business intelligence
-   analytics engineering
-   junior data engineering
-   supply chain analytics
-   marketing/growth analytics
-   marketplace/product analytics
-   operations analytics
-   applied data science
-   cloud analytics

## Why “operations analytics” works well

“Marketplace/e-commerce” gives the data concrete tables and KPIs, but “operations analytics” keeps the project broad. The same skills transfer to logistics, retail, SaaS, finance operations, sales operations, marketing analytics, and business intelligence teams.

The project should avoid feeling like a toy notebook. It should feel like a small real-world analytics pipeline:

``` text
raw messy data
→ validation and cleaning
→ processed analytical tables
→ SQL database
→ KPI reporting
→ forecasting / predictive model
→ cloud architecture documentation
```

------------------------------------------------------------------------

# 3. Main technical stack

## Primary stack

-   Python
-   pandas
-   NumPy
-   SQL
-   SQLite as beginner-friendly local database
-   PostgreSQL as optional stronger database layer
-   SQLAlchemy if useful
-   matplotlib
-   seaborn or plotly when helpful
-   scikit-learn
-   statsmodels or another lightweight forecasting approach
-   pathlib
-   logging
-   Git / GitHub
-   AWS basics, especially S3 and IAM

## Supporting R repetition

The project includes focused R repetition because the previous project was R-heavy and those skills should not fade.

R topics to repeat:

-   `mutate()`
-   `summarise()`
-   `group_by()`
-   `filter()`
-   `arrange()`
-   `left_join()`
-   `pivot_longer()`
-   `pivot_wider()`
-   `ggplot2`
-   writing reusable functions
-   comparing R workflows to Python/pandas workflows

## Key Python transfer goals

The project should repeatedly connect familiar R concepts to Python equivalents:

| R / tidyverse concept | Python / pandas equivalent |
|----|----|
| `mutate()` | `.assign()` or creating new columns |
| `summarise()` | `.agg()` |
| `group_by()` | `.groupby()` |
| `left_join()` | `.merge(..., how="left")` |
| `filter()` | boolean filtering |
| `arrange()` | `.sort_values()` |
| `ggplot2` | matplotlib, seaborn, plotly |
| R project structure | Python repo structure with `src/`, `notebooks/`, `data/`, `outputs/` |
| R functions | Python functions in reusable scripts |
| Shiny/reporting mindset | Python reports, exported tables, and README screenshots |

------------------------------------------------------------------------

# 4. Data strategy

Use **synthetic but realistic data**.

The data should be large enough and messy enough to feel closer to real work, but still controlled enough that the project does not become blocked by impossible edge cases.

The synthetic data should not be perfectly clean tutorial data. It should contain realistic problems that force decisions about:

-   missing values
-   imputation
-   duplicate records
-   bad joins
-   outliers
-   inconsistent date formats
-   inconsistent categories
-   mixed data types
-   invalid values
-   schema problems
-   wrong granularity
-   leakage in modeling features
-   how cleaning decisions affect KPIs and forecasting

## Planned tables

| Table | Approx. rows | Purpose |
|----|---:|----|
| `customers` | 20,000 | customer profile, country, region, signup date, customer segment |
| `products` | 5,000 | product, category, brand, price, listing status |
| `orders` | 80,000 | order-level transactions |
| `order_items` | 140,000 | product-level line items |
| `web_events` | 500,000 | page views, clicks, add-to-cart events, sessions |
| `marketing_spend` | 2,000 | campaign spend by date/channel |
| `inventory` | 30,000 | stock levels and stockout events |
| `returns` | 8,000 | returned orders/items and return reasons |
| `exchange_rates` | 1,000 | optional currency normalization |

## Messy data problems to simulate

| Problem | Skill trained |
|----|----|
| Missing customer region | Missing value strategy |
| Missing customer segment | Imputation / unknown category handling |
| Duplicate customers | Identity resolution / deduplication |
| Duplicate orders | Deduplication and source-system reasoning |
| Conflicting duplicate orders | Quarantine logic |
| Inconsistent date formats | Date parsing and type repair |
| Unparseable dates | Quarantine and data quality reporting |
| Category typos | String cleaning and standardization |
| Extreme order values | Outlier detection, capping, flagging |
| Negative quantities | Return/correction logic |
| Missing campaign IDs | Attribution logic |
| Invalid campaign/channel names | Category validation |
| Bad joins | Unmatched keys and granularity checks |
| Missing product IDs in order items | Join quality checks |
| Currency inconsistencies | Normalization and business logic |
| Stockout gaps | Operational KPI logic |
| Leaky model features | ML interview awareness |
| Numeric values stored as strings | Type repair |
| Currency strings like `€1,200.50` | Type conversion |
| Mixed ID formats like `123`, `CUST_123`, `"00123"` | ID normalization |
| Extra or missing columns | Schema checks |
| Suspicious type changes | Schema drift awareness |

## Controlled error rates

The synthetic generator should intentionally create messy data with controlled error rates, for example:

| Issue type                   | Example target rate |
|------------------------------|--------------------:|
| Missing customer region      |                3–8% |
| Duplicate customer rows      |                1–3% |
| Duplicate order rows         |                1–2% |
| Conflicting duplicate orders |            0.2–0.5% |
| Inconsistent date formats    |               5–10% |
| Unparseable dates            |              0.2–1% |
| Category typos               |                2–5% |
| Invalid values               |              0.5–2% |
| Extreme outliers             |              0.2–1% |
| Bad foreign keys             |              0.5–2% |
| Missing campaign IDs         |               5–15% |

The exact rates can change during implementation. The goal is to create enough issues to learn from, not to make the project impossible.

------------------------------------------------------------------------

# 5. Junior data engineering and robustness layer

This project should include a visible “pipeline defense system.”

The goal is not only to clean data once. The goal is to show that the pipeline can detect, explain, repair, quarantine, and report data problems.

## Target pipeline

``` text
raw data
→ schema checks
→ cleaning functions
→ data quality checks
→ quarantine bad rows
→ processed tables
→ load into SQL database
→ SQL KPI queries / reports / models
```

## Robustness features to build

| Robustness feature | What to build |
|----|----|
| Schema checks | Expected columns, expected data types, missing/extra column warnings |
| Type repair | Convert messy dates, numeric strings, mixed IDs, currency formats |
| Duplicate logic | Detect duplicates, remove valid duplicates, quarantine suspicious duplicates |
| Bad join checks | Row-count checks before/after joins, unmatched key reports |
| Data quality reports | CSV/Markdown reports showing failed checks |
| Quarantine files/tables | Save suspicious rows instead of silently deleting them |
| Logging | Record rows loaded, dropped, repaired, quarantined, and saved |
| Rerunnable pipeline | Delete processed files and rerun from raw without manual fixing |
| Business explanation | Explain how cleaning decisions affect KPIs, reports, forecasts, and models |

## Example data quality questions

The pipeline should answer questions like:

| Check          | Example question                                           |
|----------------|------------------------------------------------------------|
| Missing values | How many customers have missing region?                    |
| Duplicates     | How many duplicate order IDs exist?                        |
| Type problems  | Which date fields failed to parse?                         |
| Bad joins      | How many orders do not match a known customer?             |
| Outliers       | Which orders have extreme revenue?                         |
| Invalid values | Which quantities are negative when they should not be?     |
| Schema drift   | Did a file contain missing or extra columns?               |
| Row count      | Did a join accidentally multiply rows?                     |
| Granularity    | Is this table really one row per order, customer, or item? |

## Cleaning decision examples

| Problem | Possible decision |
|----|----|
| Missing region | Fill with `Unknown`, infer from country, or keep missing with flag |
| Missing product price | Use category median rather than global mean |
| Extreme order value | Keep for business reporting but flag/cap for modeling |
| Duplicate order ID | Keep latest record if identical; quarantine if conflicting |
| Bad date format | Try multiple parsers; quarantine rows still unparseable |
| Negative quantity | Treat as return/correction only if business logic supports it |
| Missing campaign ID | Label as organic/unknown rather than dropping |
| Bad join | Investigate unmatched keys before calculating KPIs |

## Data quality outputs

Expected files to introduce when relevant:

``` text
outputs/data_quality/data_quality_summary.csv
outputs/data_quality/failed_rows_customers.csv
outputs/data_quality/failed_rows_orders.csv
outputs/data_quality/failed_rows_order_items.csv
outputs/data_quality/failed_rows_products.csv
outputs/data_quality/failed_rows_returns.csv
outputs/data_quality/join_quality_report.csv
outputs/data_quality/schema_check_report.csv
outputs/data_quality/outlier_report.csv
```

## Quarantine outputs

Suspicious rows should be saved instead of silently deleted:

``` text
data/interim/quarantine_customers.csv
data/interim/quarantine_orders.csv
data/interim/quarantine_order_items.csv
data/interim/quarantine_products.csv
data/interim/quarantine_returns.csv
```

## Logging outputs

The pipeline should create logs such as:

``` text
logs/pipeline_run_YYYY_MM_DD.log
```

Example log messages:

``` text
Loaded customers_raw.csv: 20,000 rows
Found missing customer_region: 1,240 rows
Fixed date parsing errors: 312 rows
Moved invalid orders to quarantine: 47 rows
Saved dim_customers.csv: 19,953 rows
Pipeline finished successfully
```

## Config and reusable scripts

Expected engineering files:

``` text
src/00_config.py
src/utils.py
src/04_run_etl_pipeline.py
```

`src/00_config.py` should eventually store project-level settings such as:

``` python
RAW_DATA_DIR = "data/raw"
INTERIM_DATA_DIR = "data/interim"
PROCESSED_DATA_DIR = "data/processed"
OUTPUT_DIR = "outputs"
DATABASE_PATH = "data/processed/operations.db"
```

------------------------------------------------------------------------

# 6. Local database and SQL layer

The project must include a local database load step.

``` text
processed CSVs → SQLite/Postgres database → SQL queries → report outputs
```

This is important because the final portfolio story should not be only:

> “I analyzed CSVs.”

The stronger story is:

> “I built a raw-to-clean pipeline, loaded cleaned fact and dimension tables into a SQL database, and wrote analytical SQL queries on top of the database.”

## Database goals

The database layer should include:

-   table creation scripts
-   fact and dimension tables
-   primary key and foreign key thinking
-   loading processed CSVs into SQLite or PostgreSQL
-   SQL KPI queries
-   SQL data quality checks
-   SQL interview drills
-   exported KPI tables from SQL query results

## Expected SQL files

``` text
sql/01_create_tables.sql
sql/02_load_data.sql
sql/03_kpi_queries.sql
sql/04_window_function_drills.sql
sql/05_data_quality_checks.sql
sql/06_interview_queries.sql
```

## Example modeled tables

| Table                  | Type      | Grain                               |
|------------------------|-----------|-------------------------------------|
| `dim_customers`        | Dimension | one row per customer                |
| `dim_products`         | Dimension | one row per product                 |
| `fact_orders`          | Fact      | one row per order                   |
| `fact_order_items`     | Fact      | one row per order item              |
| `fact_web_events`      | Fact      | one row per event                   |
| `fact_marketing_spend` | Fact      | one row per date/channel/campaign   |
| `fact_inventory`       | Fact      | one row per product/date/location   |
| `fact_returns`         | Fact      | one row per return or returned item |

------------------------------------------------------------------------

# 7. Cloud and AWS analytics layer

This project should introduce cloud concepts in a beginner-friendly way. The goal is junior-level cloud awareness, not advanced cloud engineering.

## What the cloud means in this project

The local project structure should map conceptually to a cloud data lake:

| Local project         | Cloud equivalent                      |
|-----------------------|---------------------------------------|
| `data/raw/`           | `s3://operations-pipeline/raw/`       |
| `data/interim/`       | `s3://operations-pipeline/interim/`   |
| `data/processed/`     | `s3://operations-pipeline/processed/` |
| `outputs/`            | `s3://operations-pipeline/reports/`   |
| local Python script   | cloud ETL job concept                 |
| local SQLite/Postgres | cloud database / warehouse concept    |
| local logs            | cloud monitoring/logging concept      |

## Cloud-style S3 folder structure

Use this cloud-style structure in documentation:

``` text
s3://operations-pipeline/raw/
s3://operations-pipeline/interim/
s3://operations-pipeline/processed/
s3://operations-pipeline/reports/
```

## Beginner AWS concepts to explain

-   What the cloud is and why companies use it
-   What AWS is
-   What S3 is
-   What buckets, objects, and prefixes are
-   How S3 relates to local raw/interim/processed folders
-   What IAM is
-   Why permissions and security matter
-   Why secrets should not be committed to GitHub
-   How to use environment variables or config safely
-   Cost safety and billing alerts
-   When to simulate S3 locally instead of using real AWS
-   How local SQLite/Postgres maps conceptually to RDS, Redshift, Athena, or another cloud database/query layer
-   How to explain a simple cloud analytics architecture in interviews

## Simple cloud architecture to document

``` text
Raw CSV files
→ AWS S3 raw bucket
→ Python ETL script
→ Data quality checks
→ S3 processed layer
→ SQLite/Postgres or cloud database concept
→ SQL KPI queries
→ Excel/CSV reports + forecast model
```

## What is in scope

-   S3 basics
-   IAM basics
-   cost safety
-   local/cloud folder mapping
-   optional small S3 upload/read
-   clear architecture explanation
-   cloud-style documentation
-   a small cloud ETL/data quality mini-project

## What is not required yet

These are useful later but not necessary for this 26-day project:

-   Airflow
-   Prefect
-   dbt
-   Docker
-   Spark
-   Kubernetes
-   full production deployment
-   advanced CI/CD
-   complex AWS networking
-   advanced serverless architecture

The project should stay beginner-friendly but show the correct direction.

------------------------------------------------------------------------

# 8. Final portfolio projects

## Project 1: Operations Analytics & Forecasting Pipeline

This is the main portfolio project.

It simulates a realistic business workflow from messy raw data to cleaned processed tables, SQL analytics, KPI reporting, forecasting, and project documentation.

### Core deliverables

-   Synthetic raw data generator
-   Messy raw CSV files
-   Python cleaning pipeline
-   Schema validation checks
-   Data quality checks
-   Quarantine files
-   Data quality reports
-   Logging
-   Rerunnable ETL pipeline
-   Processed fact and dimension tables
-   SQLite/Postgres database
-   SQL table creation/loading scripts
-   SQL KPI queries
-   SQL data quality checks
-   KPI report outputs
-   Demand forecast or return prediction model
-   Excel/CSV exports
-   GitHub README with screenshots and business explanation
-   Cloud architecture documentation

### Example KPIs

| KPI                  | Meaning                                            |
|----------------------|----------------------------------------------------|
| GMV                  | Total marketplace transaction value                |
| Revenue              | Platform or business revenue                       |
| Conversion rate      | Orders divided by sessions or visits               |
| Average order value  | Revenue per order                                  |
| Return rate          | Returned items divided by sold items               |
| Stockout rate        | Unavailable inventory over total tracked inventory |
| CAC                  | Marketing spend divided by acquired customers      |
| ROAS                 | Revenue divided by marketing spend                 |
| Repeat purchase rate | Customers with more than one purchase              |
| Forecast accuracy    | Quality of demand forecast                         |

## Project 2: Cloud ETL & Data Quality Mini-Pipeline

This is the smaller supporting project.

It should show cloud-style data engineering basics without becoming too complex.

### Core deliverables

-   Small raw input files
-   Local S3-style folder structure or safe real S3 usage
-   Python ingestion script
-   Schema checks
-   Data quality checks
-   Quarantine outputs
-   Cleaned output files
-   SQL or local database export
-   Failed-check report
-   Cloud architecture diagram or notes
-   AWS cost-safety notes

------------------------------------------------------------------------

# 9. Daily roadmap

## Overall structure

| Phase | Days | Focus |
|----|---:|----|
| Setup + R-to-Python transfer | 1–5 | Project setup, R repetition, Python/pandas transition, package overview |
| SQL intensive | 6–8 | SQL drills, joins, CTEs, windows, granularity, schema design |
| Data cleaning + ETL | 9–12 | Synthetic messy data, validation, cleaning, quarantine, functions, logging |
| Analytics + modeling | 13–16 | KPIs, business reporting, forecasting, predictive modeling |
| AWS basics | 17–19 | S3, IAM, cost safety, local/cloud workflow, architecture explanation |
| Main project build | 20–23 | Final ETL, database load, SQL layer, reporting, forecasting |
| Supporting project + polish | 24–25 | Cloud ETL mini-project, README polish |
| Interview prep | 26 | Project pitch, SQL/Python/R drills, final cheat sheet |

------------------------------------------------------------------------

# 10. Day-by-day plan

| Day | Main focus | What to build/practice | Junior DE / robustness / cloud upgrade | Deliverable |
|---:|----|----|----|----|
| 1 | Project setup | Create repo, folder structure, Python environment, README draft, Git first commit | Establish clean portfolio structure from the beginning | `README.md`, `requirements.txt`, base folders, `notes/notes_day_01.md` |
| 2 | R repetition I | `mutate`, `summarise`, `group_by`, `filter`, `arrange`, simple business KPIs | Reinforce business KPI thinking before Python transfer | `r_drills/day_02_dplyr_core.R`, `notes/notes_day_02.md` |
| 3 | R repetition II | `left_join`, `pivot_longer`, `pivot_wider`, `ggplot2`, reporting plots | Start thinking about join correctness and granularity | `r_drills/day_03_joins_ggplot.R`, `notes/notes_day_03.md` |
| 4 | R-to-Python transfer | Translate R workflows into pandas | Compare tidyverse vs pandas for production-style workflows | `notebooks/day_04_r_to_python_translation.ipynb`, `r_drills/day_04_r_to_python_comparison.R` |
| 5 | Python package overview | pandas, NumPy, matplotlib, seaborn/plotly, scikit-learn, statsmodels, pathlib, logging | Introduce `pathlib`, `logging`, and project scripts | `notes/notes_day_05_python_package_map.md`, `src/day_05_package_examples.py` |
| 6 | SQL basics | SELECT, WHERE, GROUP BY, HAVING, ORDER BY, basic joins | Focus on business questions and grain awareness | `sql/day_06_sql_basics.sql` |
| 7 | SQL intermediate | CTEs, subqueries, windows, ranking, rolling totals | Use window functions for analytics engineering style queries | `sql/day_07_sql_intermediate.sql` |
| 8 | Data modeling + granularity | Fact tables, dimension tables, primary keys, foreign keys, ERD | Think about duplicates, relationships, and wrong-grain joins | `sql/day_08_schema_design.sql`, `docs/erd_notes.md` |
| 9 | Synthetic data generator | Generate customers, products, orders, order_items, marketing, inventory, returns | Generate intentionally messy raw files with controlled error rates | `src/01_generate_synthetic_data.py`, raw CSVs, `notebooks/day_09_synthetic_data_review.ipynb` |
| 10 | Messy data cleaning I | Missing values, duplicates, date parsing, category cleanup, type conversions | Add schema checks, type checks, missing-value summaries, and cleaning decisions | `src/02_clean_data.py`, interim files, `outputs/data_quality/schema_check_report.csv` |
| 11 | Messy data cleaning II | Outliers, capping, imputation, missing flags, invalid values | Add quarantine files, failed-row reports, outlier report, and data quality summary | `src/03_handle_data_quality_issues.py`, quarantine files, `outputs/data_quality/data_quality_summary.csv` |
| 12 | Reusable ETL functions | Refactor cleaning into functions, config, paths, logging, utilities | Build rerunnable pipeline runner with logging and reusable helpers | `src/00_config.py`, `src/utils.py`, `src/04_run_etl_pipeline.py`, `logs/` |
| 13 | KPI analytics | GMV, revenue, AOV, conversion, return rate, CAC, ROAS, stockout rate | Connect KPI trust to cleaned data and validation choices | `src/05_create_kpi_tables.py`, KPI outputs |
| 14 | Reporting outputs | Export Excel report, CSV tables, plots, short business interpretation | Explain reporting reliability and limitations | `src/06_export_reports.py`, `outputs/excel/operations_kpi_report.xlsx` |
| 15 | Forecasting model I | Time series aggregation, moving averages, train/test split by time, baseline forecast | Avoid leakage; explain forecast data quality assumptions | `notebooks/day_15_forecasting_baseline.ipynb` |
| 16 | Predictive model II | Return prediction or repeat purchase model, features, train/test, evaluation | Discuss feature leakage, missing-value flags, and model limitations | `notebooks/day_16_predictive_model.ipynb` |
| 17 | AWS basics I | Cloud concepts, S3, IAM, regions, buckets, cost safety, billing alerts | Explain local-to-cloud mapping and S3-style data lake structure | `aws/aws_basics_notes.md`, `aws/cloud_cost_safety_checklist.md` |
| 18 | AWS basics II | Upload raw files to S3 or simulate S3 locally, read files with Python, document workflow | Practice S3-style ingestion safely; avoid exposing secrets | `src/07_s3_ingestion.py`, `aws/s3_workflow_notes.md` |
| 19 | AWS basics III | Local DB vs cloud DB/data warehouse, architecture diagram | Explain SQLite/Postgres vs RDS/Redshift/Athena conceptually | `aws/aws_architecture_diagram.png`, `aws/cloud_architecture_notes.md` |
| 20 | Main project build I | Run full raw-to-clean ETL and validate outputs | Prove reproducibility by rerunning from raw to processed | final `data/processed/` tables, final quality reports |
| 21 | Main project build II | Load data into SQL database, run KPI queries, export analytical tables | Run SQL from database, not only pandas | `src/08_load_to_database.py`, `sql/03_kpi_queries.sql`, `outputs/tables/` |
| 22 | Main project build III | Create report/dashboard-style outputs, final plots, Excel reporting workbook | Tie report numbers back to validated SQL tables | `reports/operations_kpi_report.md`, `outputs/figures/` |
| 23 | Main project build IV | Add forecasting/predictive section, interpret model, write limitations | Explain how data quality impacts forecast/model performance | `reports/model_summary.md`, forecast/prediction outputs |
| 24 | Supporting project | Build small cloud ETL/data-quality mini-pipeline | Include failed-check reports, quarantine outputs, and cloud-style docs | `cloud_etl_mini_project/` |
| 25 | GitHub polish | README, screenshots, repo cleanup, instructions, project story, final commit | Make robustness and cloud architecture visible in portfolio | Portfolio-ready GitHub repo |
| 26 | Interview prep | SQL drills, Python drills, R refresh, project pitch, STAR stories | Practice explaining messy data, pipeline defense, SQL DB load, and cloud mapping | `interview/interview_cheat_sheet.md`, `interview/project_pitch.md` |

------------------------------------------------------------------------

# 11. Full repo structure

``` text
operations-analytics-cloud-pipeline/
│
├── README.md
├── requirements.txt
├── .gitignore
├── pyproject.toml                         # optional later
│
├── notes/
│   ├── notes_day_01.md
│   ├── notes_day_02.md
│   ├── notes_day_03.md
│   ├── notes_day_04.md
│   ├── notes_day_05.md
│   ├── notes_day_06.md
│   ├── notes_day_07.md
│   ├── notes_day_08.md
│   ├── notes_day_09.md
│   ├── notes_day_10.md
│   ├── notes_day_11.md
│   ├── notes_day_12.md
│   ├── notes_day_13.md
│   ├── notes_day_14.md
│   ├── notes_day_15.md
│   ├── notes_day_16.md
│   ├── notes_day_17.md
│   ├── notes_day_18.md
│   ├── notes_day_19.md
│   ├── notes_day_20.md
│   ├── notes_day_21.md
│   ├── notes_day_22.md
│   ├── notes_day_23.md
│   ├── notes_day_24.md
│   ├── notes_day_25.md
│   └── notes_day_26.md
│
├── data/
│   ├── raw/
│   │   ├── customers_raw.csv
│   │   ├── products_raw.csv
│   │   ├── orders_raw.csv
│   │   ├── order_items_raw.csv
│   │   ├── web_events_raw.csv
│   │   ├── marketing_spend_raw.csv
│   │   ├── inventory_raw.csv
│   │   ├── returns_raw.csv
│   │   └── exchange_rates_raw.csv
│   │
│   ├── interim/
│   │   ├── customers_interim.csv
│   │   ├── products_interim.csv
│   │   ├── orders_interim.csv
│   │   ├── quarantine_customers.csv
│   │   ├── quarantine_orders.csv
│   │   ├── quarantine_order_items.csv
│   │   ├── quarantine_products.csv
│   │   └── quarantine_returns.csv
│   │
│   ├── processed/
│   │   ├── dim_customers.csv
│   │   ├── dim_products.csv
│   │   ├── fact_orders.csv
│   │   ├── fact_order_items.csv
│   │   ├── fact_web_events.csv
│   │   ├── fact_marketing_spend.csv
│   │   ├── fact_inventory.csv
│   │   ├── fact_returns.csv
│   │   └── operations.db
│   │
│   └── external/
│       └── README.md
│
├── src/
│   ├── 00_config.py
│   ├── 01_generate_synthetic_data.py
│   ├── 02_clean_data.py
│   ├── 03_handle_data_quality_issues.py
│   ├── 04_run_etl_pipeline.py
│   ├── 05_create_kpi_tables.py
│   ├── 06_export_reports.py
│   ├── 07_s3_ingestion.py
│   ├── 08_load_to_database.py
│   ├── 09_forecasting_model.py
│   ├── 10_predictive_model.py
│   └── utils.py
│
├── sql/
│   ├── day_06_sql_basics.sql
│   ├── day_07_sql_intermediate.sql
│   ├── day_08_schema_design.sql
│   ├── 01_create_tables.sql
│   ├── 02_load_data.sql
│   ├── 03_kpi_queries.sql
│   ├── 04_window_function_drills.sql
│   ├── 05_data_quality_checks.sql
│   └── 06_interview_queries.sql
│
├── r_drills/
│   ├── day_02_dplyr_core.R
│   ├── day_03_joins_ggplot.R
│   └── day_04_r_to_python_comparison.R
│
├── notebooks/
│   ├── day_04_r_to_python_translation.ipynb
│   ├── day_09_synthetic_data_review.ipynb
│   ├── day_10_cleaning_decisions.ipynb
│   ├── day_13_kpi_eda.ipynb
│   ├── day_15_forecasting_baseline.ipynb
│   ├── day_16_predictive_model.ipynb
│   └── day_23_final_model_review.ipynb
│
├── reports/
│   ├── operations_kpi_report.md
│   ├── cleaning_decisions_report.md
│   ├── model_summary.md
│   └── interview_project_summary.md
│
├── outputs/
│   ├── data_quality/
│   │   ├── data_quality_summary.csv
│   │   ├── failed_rows_customers.csv
│   │   ├── failed_rows_orders.csv
│   │   ├── failed_rows_order_items.csv
│   │   ├── failed_rows_products.csv
│   │   ├── failed_rows_returns.csv
│   │   ├── join_quality_report.csv
│   │   ├── schema_check_report.csv
│   │   └── outlier_report.csv
│   │
│   ├── figures/
│   │   ├── gmv_trend.png
│   │   ├── revenue_by_channel.png
│   │   ├── return_rate_by_category.png
│   │   ├── stockout_rate_trend.png
│   │   ├── forecast_vs_actual.png
│   │   └── model_feature_importance.png
│   │
│   ├── tables/
│   │   ├── kpi_summary.csv
│   │   ├── channel_performance.csv
│   │   ├── product_category_performance.csv
│   │   ├── customer_segment_summary.csv
│   │   └── forecast_results.csv
│   │
│   └── excel/
│       └── operations_kpi_report.xlsx
│
├── logs/
│   └── .gitkeep
│
├── aws/
│   ├── aws_basics_notes.md
│   ├── cloud_cost_safety_checklist.md
│   ├── s3_workflow_notes.md
│   ├── cloud_architecture_notes.md
│   └── aws_architecture_diagram.png
│
├── cloud_etl_mini_project/
│   ├── README.md
│   ├── raw_input/
│   ├── processed_output/
│   ├── quality_reports/
│   ├── quarantine/
│   ├── run_cloud_etl.py
│   └── data_quality_checks.py
│
├── docs/
│   ├── erd_notes.md
│   ├── data_dictionary.md
│   ├── business_glossary.md
│   ├── project_decisions.md
│   └── pipeline_architecture.md
│
└── interview/
    ├── sql_interview_drills.sql
    ├── python_interview_drills.py
    ├── r_refresh_drills.R
    ├── project_pitch.md
    └── interview_cheat_sheet.md
```

------------------------------------------------------------------------

# 12. Documentation goals

The GitHub README should eventually make these points visible:

-   project purpose
-   business case
-   dataset description
-   messy data problems
-   pipeline architecture
-   data quality checks
-   quarantine strategy
-   database schema
-   example SQL queries
-   KPI outputs
-   forecasting/modeling output
-   cloud mapping
-   screenshots or diagrams
-   how to run the project
-   limitations and next steps

## Important README story

The README should make the project feel like a professional workflow, not a class exercise.

Strong wording to build toward:

> “This project simulates a small operations analytics pipeline. Raw synthetic marketplace data is intentionally messy. The pipeline validates schemas, repairs types, handles missing values and duplicates, quarantines suspicious rows, creates data quality reports, loads clean fact and dimension tables into a SQL database, runs KPI queries, exports reports, builds a forecast/model, and documents how the workflow would map to AWS S3 and a cloud analytics architecture.”

------------------------------------------------------------------------

# 13. Interview explanation goals

By the end, the project should support explanations like:

## Data cleaning explanation

> “The raw data was intentionally messy. I added schema checks, type checks, missing-value summaries, duplicate detection, outlier checks, and join-quality reports. I did not silently delete every bad row. Suspicious records were saved into quarantine outputs so the cleaning decisions were transparent.”

## SQL explanation

> “After cleaning, I loaded processed fact and dimension tables into a local SQL database. I then wrote SQL queries for KPIs such as GMV, revenue, AOV, return rate, conversion rate, CAC, ROAS, repeat purchase rate, and stockout rate.”

## Cloud explanation

> “The project runs locally, but the structure maps to a cloud analytics workflow. Local folders like `data/raw`, `data/interim`, `data/processed`, and `outputs` correspond to S3 prefixes such as `s3://operations-pipeline/raw/`, `interim/`, `processed/`, and `reports/`. The same Python ETL logic could read from S3, write processed data back to S3, and load a cloud database or warehouse.”

## Modeling explanation

> “The forecast/model is built only after the data is cleaned and validated. I considered leakage, missing-value flags, outliers, and the business interpretation of model results.”

------------------------------------------------------------------------

# 14. Teaching style for this project

When working through this project day by day:

-   Teach step by step, day by day.
-   Give clear tasks, explanations, code templates, and end-of-day deliverables.
-   Keep the work practical, intense, structured, and job-oriented.
-   Prefer real project work over abstract theory.
-   Explain why each skill matters for real data jobs.
-   Use complete copy-paste code blocks when creating or replacing files.
-   Keep naming conventions consistent, especially notes files such as `notes_day_01.md`, `notes_day_02.md`, etc.
-   Include realistic debugging and messy-data thinking, not only clean tutorial examples.
-   Explain both the code and the professional reasoning behind the project structure.
-   End each day with a short summary and the next-day focus.

------------------------------------------------------------------------

# 15. Scope control

This project should be ambitious but not overwhelming.

## Must-have

-   Python data cleaning
-   realistic messy synthetic data
-   SQL practice
-   data quality checks
-   quarantine outputs
-   local database load
-   KPI reports
-   forecasting or predictive model
-   beginner AWS/S3/IAM/cost-safety notes
-   cloud-style architecture documentation
-   polished GitHub README
-   interview prep

## Nice-to-have if time allows

-   PostgreSQL instead of SQLite
-   small real S3 upload/read
-   SQLAlchemy
-   simple architecture diagram image
-   basic automated tests
-   a small CLI-style pipeline runner
-   extra SQL interview drills

## Out of scope for now

-   full production cloud deployment
-   Airflow/Prefect orchestration
-   dbt
-   Docker
-   Spark
-   complex CI/CD
-   complex AWS services
-   advanced MLOps
