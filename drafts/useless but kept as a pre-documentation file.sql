-- since this is my fist SQL project, I will be documenting my learning journey alongside the code I write for the project.
-- further SQL projects will be more professional and will not include my learning journey.
----------------------------------------
----------------------------------------
-- 0. Load Central_Superstore.xlsx into SQL Server first:
----------------------------------------
----------------------------------------
-- I did all that from SQL management server.
-- faced a problem where I couldn't import the file, and found out I have to download business intellegence from visual studio installer.
-- now make sure to use the correct database:
USE [Mini Project 2];
-- now just checking if the table is imported correctly:
SELECT TOP (1000) [Row ID]
      ,[Order ID]
      ,[Order Date]
      ,[Ship Date]
      ,[Ship Mode]
      ,[Customer ID]
      ,[Customer Name]
      ,[Segment]
      ,[Country]
      ,[City]
      ,[State]
      ,[Postal Code]
      ,[Region]
      ,[Product ID]
      ,[Category]
      ,[Sub-Category]
      ,[Product Name]
      ,[Sales]
      ,[Quantity]
      ,[Discount]
      ,[Profit]
  FROM Central_Region
  -- removed the dollar sign from the table name as suggested from a youtube tutorial.
  -- alright looks like I imported the xlsx file into a table successfully.

  -- Choosing primary key:
  ALTER TABLE Central_Region
  ADD CONSTRAINT pk_rowid PRIMARY KEY ("Row ID")
  -- altering column type to not null to enable making it primary key
  ALTER TABLE Central_Region
  ALTER COLUMN "Row ID" nvarchar(255) NOT NULL
  -- made Row ID the primary key since Order ID contains dublicates.
  -- I think worrying about keys now isn't worth it, I'll now go to the Data modelling & Star-schema phase:
  --------------------------------------
  --------------------------------------
  -- 1. Data Modeling & Star Schema:
  --------------------------------------
  --------------------------------------
  -- I began by learning about data modeling and star schema design.
  -- I learned that a star schema consists of a central fact table connected to multiple dimension tables.
  -- I also learned how to model the data from the Central_Superstore dataset into a star schema format using erdplus.com.
  -- I downloaded the ERD diagram and saved it as a PNG picture and called it "erdplus pre star schema design.png"
  -- I called it "pre star schema design" since I still believe more changes will arise.
  --------------------------------------
  --------------------------------------
  -- Now off to watching "SQL Data Warehouse from Scratch | Full Hands-On Data Engineering Project" 
  -- This video is a 4-hour tutorial on data warehousing and star schema implementation that was suggested by our instructor Eng. Waleed Mouhammed.
  --------------------------------------
  --------------------------------------
  -- Choosing a data architecture:
  -- for this project we will build a data warehouse.
  -- we will use the medallion architecture for our data warehouse.
  -- I learned that the medallion architecture consists of three layers: bronze, silver, and gold.
  -- The bronze layer is the raw data layer, no transformations, no cleaning, no modelling, just raw data.
  -- the bronze layer is for data engineers only, since it contains raw data that is not ready for analysis.
  -- the silver layer is the cleaned and standradized data layer, most transformations, but no modelling nor business transformations yet.
  -- the silver layer is for data engineers and data analysts, since it contains cleaned and standardized data that is ready for analysis, but not yet modelled.
  -- the gold layer is the business-ready data layer, where the data is modelled and ready for analysis, only for data analysts and business users.
  -- the gold layer is where the star schema is implemented, and the data is ready for business intelligence and analytics.
  -- I think that's a solid understanding of the medallion architecture and it's layers.
  -- This will hopefully make us follow the separation of concerns principle (SOP), each layer has it's own purpose, no overlapping.
  ---------------------------------------
  ---------------------------------------
  -- I ended up following the video tutorial and it was from scratch, basically this file is useless now, but I will keep it for documentation purposes.
  -- I built the bronze layer, where I created a schema called "bronze" and created a table called "bronze.csv_central_superstore" with the same structure as the Central_Region table.
  -- I then created a stored procedure called "bronze.load_bronze" that loads the data from the Central_Region table into the bronze.csv_central_superstore table.
  -- I intend to make a data flow diagram but I don't have enough time to make one, so I will just describe the data flow in words.
  -- The data flow is as follows:
  -- first the xlsx file must be converted to a csv file using the automatic script that I provided in the project folder.
  -- then the csv file must be loaded into the bronze.csv_central_superstore table using the bronze.load_bronze stored procedure.
  -- the data flow will be continued after the silver layer is built.
  -- now I'll commit the changes to the repository and continue with the silver layer.
  -- I plan on converting this file into a markdown file once I finish the project, so that it can be viewed on github.
  -----------------------------------------
  -----------------------------------------
