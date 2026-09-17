# SQL Data Warehouse & Business Analytics — Central Superstore

This is my Mini Project 2 for the DEPI Data Analyst Trainee program (Round 5). The task was to take a single retail dataset (Central Superstore) and turn it into a proper analytical data warehouse: normalize it into a star schema, write advanced SQL against it, build views and stored procedures for KPIs, and produce business analytics on profitability, customer behavior, and sales trends. This is my first SQL project, so some of the comments inside the scripts are basically me thinking out loud while learning the concepts — I kept them instead of cleaning everything up, since it's an honest record of how the project actually got built.

I followed the Medallion Architecture (Bronze → Silver → Gold), based mainly on "SQL Data Warehouse from Scratch | Full Hands-On Data Engineering Project", which our instructor Eng. Waleed Mouhammed recommended.

---

## Dataset

Unlike the typical version of this project (which usually integrates a CRM + ERP source), mine is built on a **single source**: `Central_Superstore.xlsx`, a retail sales dataset with order, customer, product, and shipping details for one region.

- `datasets/source_xlsx/central_superstore.xlsx` — the original file
- `datasets/source_csv/central_superstore.csv` — converted version, since `BULK INSERT` needs CSV

I wrote a small script (`scripts/0 xlsx to csv automatic converter/xlsx_to_csv.py`, with a `.bat` wrapper) to automate that conversion instead of exporting manually every time I touched the source file.

---

## Architecture

```
Excel (.xlsx) → CSV → Bronze → Silver → Gold (star schema)
```

- **Bronze** — raw data, loaded as-is from the CSV with `BULK INSERT`. No cleaning, no renaming, nothing. This layer exists purely so I always have an untouched copy of what came in.
- **Silver** — same structure as bronze, since the dataset turned out to already be clean (no real nulls, no duplicate row IDs, consistent formatting). The one thing I added here is a derived `total_price` column. Truncate-and-reload pattern, same as bronze.
- **Gold** — the actual star schema, built as views on top of silver: `dim_customers`, `dim_products`, `dim_order_details`, and `fact_sales`. I went with views instead of physical tables since there was no transformation heavy enough to justify materializing them, and it kept the whole thing simpler to rebuild.

Star schema diagram: `erdplus diagram for the project star schema.png` (built with erdplus.com — there's also an earlier "pre" version in `drafts/`, from before I settled on the final column layout and naming).

---

## Repository Structure

```
sql_data_warehouse_business_analytics/
│
├── datasets/
│   ├── source_xlsx/                 # original Central Superstore file
│   └── source_csv/                  # converted CSV used for BULK INSERT
│
├── docs/
│   ├── gold_layer_data_catalog.md   # column-level catalog of the gold views
│   └── naming_conventions.md        # snake_case rules, dwh_ prefix, _key suffix, etc.
│
├── drafts/
│   ├── erdplus pre star schema design.png
│   └── useless but kept as a pre-documentation file.sql   # my early learning-journey notes, kept for the record
│
├── scripts/
│   ├── 0 xlsx to csv automatic converter/   # xlsx_to_csv.py + .bat wrapper
│   ├── 1 init_database.sql                  # creates the DataWarehouse DB + bronze/silver/gold schemas
│   ├── 2 bronze/                            # DDL + load procedure for raw data
│   ├── 3 silver/                            # DDL + load procedure (adds total_price)
│   ├── 4 gold/                              # star schema views
│   ├── 5 data exploration/                  # database, dimension, date range, measures exploration
│   └── 6 data analysis/                     # magnitude, ranking, change-over-time, cumulative,
│                                             # performance, part-to-whole, and the two KPI reports
│                                             # (report_customers, report_products)
│
├── tests/
│   ├── quality_pre-checks_bronze.sql
│   └── quality_checks_silver.sql
│
└── README.md
```

Scripts are numbered in the order they're meant to be run — `1 init_database.sql` first, all the way through the gold layer, then exploration and analysis.

---

## What's covered against the rubric

- **Data Modeling**: star schema with 3 dimensions + 1 fact, surrogate keys, snake_case naming (see `docs/naming_conventions.md`)
- **Advanced SQL**: joins (fact-to-dimension), subqueries, CTEs, CASE statements — mostly in the `6 data analysis` scripts, especially `05_magnitude_analysis.sql` through `10_part_to_whole_analysis.sql`
- **Views & Stored Procedures**: `bronze.load_bronze` and `silver.load_silver` procedures; `gold.report_customers` and `gold.report_products` are the KPI-focused views (recency, average order value, customer/product segmentation, lifespan)
- **Business Analytics**: change-over-time, cumulative, and performance analysis scripts cover sales trends; the two report views cover customer behavior and product profitability
- **Documentation**: this README, the data catalog, and the naming conventions doc

Full rubric: `drafts/Mini-Project-2-Grading-Rubric.docx`

---

## Tools used

- SQL Server / SSMS (had to install the Business Intelligence component from the Visual Studio Installer to get the import wizard working)
- Python (just for the xlsx → csv conversion step)
- erdplus.com for the schema diagram
- Git/GitHub for version control

---

## About me

I'm Mohamed Ahmed Rashed, an accounting graduate from Alexandria University pivoting into data analytics through DEPI. This is my first real SQL project — feedback is welcome.

GitHub: [@bshni](https://github.com/bshni)
