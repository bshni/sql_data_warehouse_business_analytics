/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/
USE DataWarehouse;
GO
-- Find the Total sales price
SELECT SUM(total_price) AS total_sales FROM gold.fact_sales

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Find the average selling price per prodcut
SELECT AVG(sales) AS avg_price FROM gold.fact_sales

-- Find the Total number of Orders
SELECT COUNT(order_details_key) AS total_orders FROM gold.dim_order_details;
SELECT COUNT(DISTINCT order_details_key) AS total_orders FROM gold.dim_order_details;

-- Find the total number of products
SELECT COUNT(DISTINCT product_name) AS total_products FROM gold.dim_products

-- Find the total number of customers
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.dim_customers;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(total_price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Selling Price', AVG(sales) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_details_key) FROM gold.dim_order_details
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;
