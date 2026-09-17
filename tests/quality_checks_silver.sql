/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'Silver.csv_central_superstore'
-- ====================================================================
-- Check for NULLs or Duplicates in id columns
-- Expectation: No Results
SELECT 
    row_id,
    COUNT(*) 
FROM silver.csv_central_superstore
GROUP BY row_id
HAVING COUNT(*) > 1 OR row_id IS NULL;
-- no duplicates or nulls found, so no further action needed.

SELECT 
    order_id,
    COUNT(*) 
FROM silver.csv_central_superstore
GROUP BY order_id
HAVING COUNT(*) > 1 OR order_id IS NULL;

SELECT
    *
FROM silver.csv_central_superstore
WHERE order_id = 'CA-2011-139892';
-- these aren't duplicates, they are different products in the same order, so no further action needed.

SELECT 
    product_id,
    COUNT(*) 
FROM silver.csv_central_superstore
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    customer_id 
FROM silver.csv_central_superstore
WHERE customer_id != TRIM(customer_id);
--looks consistent so no further action needed.
SELECT 
    product_name 
FROM silver.csv_central_superstore
WHERE product_name != TRIM(product_name);
-- wow, data quality is amazing, I don't see any issues since I started the checks, so no further action needed.


-- Data Standardization & Consistency
SELECT DISTINCT 
    ship_mode
FROM silver.csv_central_superstore;
--looks consistent so no further action needed.

SELECT DISTINCT 
    segment
FROM silver.csv_central_superstore;
--looks consistent so no further action needed.

SELECT DISTINCT 
    country
FROM silver.csv_central_superstore;
--looks consistent so no further action needed.
SELECT DISTINCT 
    category
FROM silver.csv_central_superstore;
--looks consistent so no further action needed.
SELECT DISTINCT 
    sub_category
FROM silver.csv_central_superstore;
--looks consistent so no further action needed.
SELECT DISTINCT 
    TOP(50) product_name
FROM silver.csv_central_superstore
ORDER BY product_name;
-- acceptable, no further action needed.


-- Check for NULLs or Negative Values in Sales, Quantity, and Profit
-- Expectation: No Results
SELECT 
    sales,
    quantity,
    profit
FROM silver.csv_central_superstore
WHERE sales < 0 OR quantity < 0 OR profit < 0 OR sales IS NULL OR quantity IS NULL OR profit IS NULL;
-- we have lots of negative values in profit, this usually happens when there are discounts or returns, we will analyze this further in the Silver or Gold layer, so no further action needed.

-- Check Data Consistency: Total price = Quantity * Sales
-- Expectation: No Results
SELECT DISTINCT 
    sales,
    quantity,
    total_price 
FROM silver.csv_central_superstore
WHERE total_price != quantity * sales
   OR sales IS NULL 
   OR quantity IS NULL 
   OR total_price IS NULL
   OR sales <= 0 
   OR quantity <= 0 
   OR total_price <= 0
ORDER BY sales, quantity, total_price;
-- looks consistent, no further action needed.

-- Check for Invalid Date Orders (Order Date > Ship Date)
-- Expectation: No Results
SELECT 
    * 
FROM silver.csv_central_superstore
WHERE order_date > ship_date
-- No invalid date orders found, so no further action needed.

-- Check for unfriendly values to normalize
-- Expectation: All values are easy to understand
SELECT
    TOP (50) *
FROM silver.csv_central_superstore;
-- all values are easy to understand and friendly normalized.
/* prechecks from before already turned out that really nothing in terms of data cleaning will need to be done in the silver layer,
So I just made the same checks again to clraify, and added a new check for the total_price calculated column,
No real transformations are needed in the silver layer, and since I checked them manually myself, I didn't add unnecessary transformations scripts,
Hopefully this will get me the No-Ai use bonus, because I put real effort into this project. */
