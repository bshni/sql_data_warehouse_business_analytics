/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' Tables
===============================================================================
*/
USE DataWarehouse;
GO
IF OBJECT_ID('silver.csv_central_superstore', 'U') IS NOT NULL
    DROP TABLE silver.csv_central_superstore;
GO

CREATE TABLE silver.csv_central_superstore (
    row_id          INT,
    order_id        NVARCHAR(50),
    order_date      DATE,
    ship_date       DATE,
    ship_mode       NVARCHAR(50),
    customer_id     NVARCHAR(50),
    customer_name   NVARCHAR(100),
    segment         NVARCHAR(50),
    country         NVARCHAR(50),
    city            NVARCHAR(50),
    state           NVARCHAR(50),
    postal_code     NVARCHAR(20),
    region          NVARCHAR(50),
    product_id      NVARCHAR(50),
    category        NVARCHAR(50),
    sub_category    NVARCHAR(50),
    product_name    NVARCHAR(500),
    sales           FLOAT,
    quantity        INT,
    total_price     FLOAT,
    discount        FLOAT,
    profit          FLOAT,
    dwh_load_date    DATETIME2 DEFAULT GETDATE()
);
GO
-- just added a total price column structure derived from (sales * quantity) since this can be useful later in the gold layer.

SELECT TOP(1000) *
FROM silver.csv_central_superstore
