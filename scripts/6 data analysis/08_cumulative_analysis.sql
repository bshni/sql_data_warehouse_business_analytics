/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/
USE DataWarehouse;
GO
-- Calculate the total sales per month 
-- and the running total of sales over time 
SELECT
	order_date,
	total_price,
	SUM(total_price) OVER (ORDER BY order_date) AS running_total_price,
	AVG(avg_sales) OVER (ORDER BY order_date) AS moving_average_sales
FROM
(
    SELECT 
        DATETRUNC(year, order_date) AS order_date,
        SUM(total_price) AS total_price,
        AVG(sales) AS avg_sales
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_order_details AS od
    ON fs.order_details_key = od.order_details_key
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) t
