/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'Bronze' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Bronze Layer.
    - This is a pre-check before loading data into the Silver Layer.
    - Only investigate and flag any discrepancies found during the checks.
    - This will make the data loading and transformation process more robust and reliable in the Silver Layer.
===============================================================================
*/

-- ====================================================================
-- Checking 'Bronze.csv_central_superstore'
-- ====================================================================
-- Check for NULLs or Duplicates in id columns
-- Expectation: No Results
SELECT 
    row_id,
    COUNT(*) 
FROM bronze.csv_central_superstore
GROUP BY row_id
HAVING COUNT(*) > 1 OR row_id IS NULL;
-- no duplicates or nulls found, so no further action needed.

SELECT 
    order_id,
    COUNT(*) 
FROM bronze.csv_central_superstore
GROUP BY order_id
HAVING COUNT(*) > 1 OR order_id IS NULL;

SELECT
    *
FROM bronze.csv_central_superstore
WHERE order_id = 'CA-2011-139892';
-- these aren't duplicates, they are different products in the same order, so no further action needed.

SELECT 
    product_id,
    COUNT(*) 
FROM bronze.csv_central_superstore
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    customer_id 
FROM bronze.csv_central_superstore
WHERE customer_id != TRIM(customer_id);
--looks consistent so no further action needed.
SELECT 
    product_name 
FROM bronze.csv_central_superstore
WHERE product_name != TRIM(product_name);
-- wow, data quality is amazing, I don't see any issues since I started the checks, so no further action needed.


-- Data Standardization & Consistency
SELECT DISTINCT 
    ship_mode
FROM bronze.csv_central_superstore;
--looks consistent so no further action needed.

SELECT DISTINCT 
    segment
FROM bronze.csv_central_superstore;
--looks consistent so no further action needed.

SELECT DISTINCT 
    country
FROM bronze.csv_central_superstore;
--looks consistent so no further action needed.
SELECT DISTINCT 
    category
FROM bronze.csv_central_superstore;
--looks consistent so no further action needed.
SELECT DISTINCT 
    sub_category
FROM bronze.csv_central_superstore;
--looks consistent so no further action needed.
SELECT DISTINCT 
    TOP(50) product_name
FROM bronze.csv_central_superstore
ORDER BY product_name;
--acceptable, no further action needed.


-- Check for NULLs or Negative Values in Sales, Quantity, and Profit
-- Expectation: No Results
SELECT 
    sales,
    quantity,
    profit
FROM bronze.csv_central_superstore
WHERE sales < 0 OR quantity < 0 OR profit < 0 OR sales IS NULL OR quantity IS NULL OR profit IS NULL;
-- we have lots of negative values in profit, this usually happens when there are discounts or returns, we will analyze this further in the Silver or Gold layer, so no further action needed.


-- Check for Invalid Date Orders (Order Date > Ship Date)
-- Expectation: No Results
SELECT 
    * 
FROM bronze.csv_central_superstore
WHERE order_date > ship_date
-- No invalid date orders found, so no further action needed.

-- Check for unfriendly values to normalize
-- Expectation: All values are easy to understand
SELECT
    TOP (50) *
FROM bronze.csv_central_superstore;
-- all values are easy to understand and friendly normalized.
-- prechecks turned out that really nothing in terms of data cleaning will need to be done in the silver layer.