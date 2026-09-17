/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
-- USE DataWarehouse; --execute this alone to set the context to the DataWarehouse database first, then execute the stored procedure.
--  EXEC bronze.load_bronze; -- test after creating the stored procedure to load data into the bronze layer.

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CSV Tables';
		PRINT '------------------------------------------------';
		-- to avoid dublicate data, we will truncate the table before loading data into it.
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.csv_central_superstore';
		TRUNCATE TABLE bronze.csv_central_superstore;

		PRINT '>> Inserting Data Into: bronze.csv_central_superstore';
		BULK INSERT bronze.csv_central_superstore
		FROM 'C:\Users\Mohamed Ahmed Rashed\sql_data_warehouse_business_analytics\datasets\source_csv\central_superstore.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			FORMAT = 'CSV',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> -------------'
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
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

/*SELECT *
FROM bronze.csv_central_superstore;
-- hopefully this will return 2323 rows, which is the (total number of rows) - (1) in the original CSV file (header row is not counted).
SELECT COUNT(*)
FROM bronze.csv_central_superstore;
*/

END;
