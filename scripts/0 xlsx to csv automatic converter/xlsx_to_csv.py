# xlsx_to_csv.py
#
# Converts central_superstore.xlsx into central_superstore.csv so I can load
# it with SQL Server's BULK INSERT (BULK INSERT can't read .xlsx directly).
#
# Run it with:
#   python xlsx_to_csv.py
#
# The paths below are hardcoded to my project folder since this is a one-off
# script just for this dataset, not a general tool.

import pandas as pd

SRC = r"C:\Users\Mohamed Ahmed Rashed\sql_data_warehouse_business_analytics\datasets\source_xlsx\central_superstore.xlsx"
DST = r"C:\Users\Mohamed Ahmed Rashed\sql_data_warehouse_business_analytics\datasets\source_csv\central_superstore.csv"

df = pd.read_excel(SRC)

# Order Date and Ship Date come in as datetime objects from pandas, but
# BULK INSERT expects plain ISO dates (YYYY-MM-DD), so I'm converting them
# here instead of dealing with it in SQL later.
for col in ["Order Date", "Ship Date"]:
    df[col] = pd.to_datetime(df[col]).dt.strftime("%Y-%m-%d")

df.to_csv(DST, index=False, encoding="utf-8")

print(f"Done. Saved to {DST}")
