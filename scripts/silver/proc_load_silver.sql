/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE Silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CSV Tables';
		PRINT '------------------------------------------------';

		-- Loading silver.csv_central_superstore
    SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.csv_central_superstore';
TRUNCATE TABLE silver.csv_central_superstore;
PRINT '>> Inserting Data Into: silver.csv_central_superstore';
INSERT INTO silver.csv_central_superstore (
    row_id, order_id, order_date, ship_date, ship_mode, customer_id,
    customer_name, segment, country, city, state, postal_code, region,
    product_id, category, sub_category, product_name, sales, quantity, total_price,
    discount, profit
)
SELECT
    row_id, order_id, order_date, ship_date, ship_mode, customer_id,
    customer_name, segment, country, city, state, postal_code, region,
    product_id, category, sub_category, product_name, sales, quantity, sales * quantity AS total_price,
    discount, profit
FROM bronze.csv_central_superstore;

-- just added a total price column derived from (sales * quantity) since this can be useful later in the gold layer.


		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END

-- A quick check for the output table:
/*
SELECT *
FROM silver.csv_central_superstore
*/ 
