/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key, -- Surrogate key
    customer_id,
    segment,
    customer_name,
    country,
    state,
    city,
    postal_code
FROM silver.csv_central_superstore ci
GO
-- quick check: SELECT TOP 10 * FROM gold.dim_customers;

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_key, -- Surrogate key
    product_id       AS product_id,
    product_name     AS product_name,
    category        AS category,
    sub_category     AS sub_category
FROM silver.csv_central_superstore 
GO
-- quick check: SELECT TOP 10 * FROM gold.dim_products;

-- =============================================================================
-- Create Dimension: gold.dim_order_details
-- =============================================================================
IF OBJECT_ID('gold.dim_order_details', 'V') IS NOT NULL
    DROP VIEW gold.dim_order_details;
GO

CREATE VIEW gold.dim_order_details AS
SELECT
    ROW_NUMBER() OVER (ORDER BY order_id, order_date) AS order_details_key, -- Surrogate key
    order_id,
    order_date,
    ship_date,
    ship_mode     
FROM silver.csv_central_superstore
GO
-- quick check: SELECT TOP 10 * FROM gold.dim_order_details;

-- I'm glad I thought about the logical way to order the columns before in the pre schema diagram shown in drafts folder.
-- creating views turned out to be the easiest alternative, I'm glad I picked this approach.
-- followed the naming convention for the fact table, and the dimensions, and also the surrogate keys.
-- the naming convention is the snake_case, I kept it simple as it's followed in the whole project, forgot to mention that before.
-- a new updated schema diagram already created with the new naming convention and the data modelling approach.
-- I created it online using erdplus.com, didn't decide yet where to export it.

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sales,
    quantity,
    total_price,
    discount,
    profit,
    pr.product_key,
    cu.customer_key,
    od.order_details_key
FROM silver.csv_central_superstore sd
LEFT JOIN gold.dim_products pr
    ON sd.product_id = pr.product_id
LEFT JOIN gold.dim_customers cu
    ON sd.customer_id = cu.customer_id
LEFT JOIN gold.dim_order_details od
    ON sd.order_id = od.order_id;
GO

-- quick check: SELECT TOP 10 * FROM gold.fact_sales;
