-- Creating the Database
create DATABASE Retail_project;

-- Using the Database
USE Retail_project;

-- Creating a general table for all data with basic definitions
CREATE TABLE Transactions (
Transaction_ID INT primary key ,
Customer_ID INT,
Category VARCHAR(50),
Item VARCHAR(50),
Price_Per_Unit DECIMAL(10,2),
Quantity INT,
Total_Spent DECIMAL(10,2),
Payment_Method VARCHAR(50),
Location VARCHAR(100),
Transaction_Date DATE,
Discount_Applied DECIMAL(10,2)
);
--  Checking the tables
show tables;
## Checking table structure
DESCRIBE TRANSACTIONS;


SELECT COUNT(*) FROM Transactions;
## יש לי שגיאה כלשהי ,הטבלה לא עלתה כראטי
LOAD DATA INFILE 'G:\My Drive\data analysis\project for job\retail_store_sales.csv'
INTO TABLE Transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- Data upload not completed yet
-- Check Secure File Access Restrictions
SHOW VARIABLES LIKE 'secure_file_priv';
-- Adjusted File Location to Enable Data Import
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retail_store_sales.csv'
INTO TABLE Transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- Adjusting Transaction_ID Type
ALTER TABLE Transactions
MODIFY Transaction_ID VARCHAR(20);
-- Repeating the data upload operation
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retail_store_sales.csv'
INTO TABLE Transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- Adjusting Customer_ID Type
ALTER TABLE Transactions
MODIFY Customer_ID VARCHAR(20);
-- upload data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retail_store_sales.csv'
INTO TABLE Transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- Adjusting  Discount_Applied Type
ALTER TABLE Transactions
MODIFY Discount_Applied VARCHAR(50);
-- upload data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retail_store_sales.csv'
INTO TABLE Transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Adjusting  Price_Per_Unit Type
ALTER TABLE Transactions
MODIFY Price_Per_Unit DECIMAL(10,2) NULL;
-- upload data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retail_store_sales.csv'
INTO TABLE Transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Adjusting  Price_Per_Unit Type
ALTER TABLE Transactions
MODIFY Total_Spent DECIMAL(10,2) NULL;
-- Temporary staging table setup and data load
CREATE TABLE Transactions_staging (
    Transaction_ID VARCHAR(50),
    Customer_ID VARCHAR(50),
    Category VARCHAR(100),
    Item VARCHAR(100),
    Price_Per_Unit VARCHAR(50),
    Quantity VARCHAR(50),
    Total_Spent VARCHAR(50),
    Payment_Method VARCHAR(50),
    Location VARCHAR(100),
    Transaction_Date VARCHAR(50),
    Discount_Applied VARCHAR(50)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retail_store_sales.csv'
INTO TABLE Transactions_staging
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- -- Transferring data to Transactions table with column type conversion
INSERT INTO Transactions (
    Transaction_ID,
    Customer_ID,
    Category,
    Item,
    Price_Per_Unit,
    Quantity,
    Total_Spent,
    Payment_Method,
    Location,
    Transaction_Date,
    Discount_Applied
)
SELECT
    Transaction_ID,
    Customer_ID,
    Category,
    Item,
    CAST(NULLIF(Price_Per_Unit, '') AS DECIMAL(10,2)),
    CAST(NULLIF(Quantity, '') AS DECIMAL(10,2)),
    CAST(NULLIF(Total_Spent, '') AS DECIMAL(10,2)),
    Payment_Method,
    Location,
    STR_TO_DATE(Transaction_Date, '%Y-%m-%d'),
    CASE 
        WHEN LOWER(Discount_Applied) = 'true' THEN 1
        WHEN LOWER(Discount_Applied) = 'false' THEN 0
        ELSE NULL
    END
FROM Transactions_staging;

-- Checking the date format
SELECT DISTINCT Transaction_Date FROM Transactions_staging;

-- Listing all existing tables in the database
show tables;
-- Checking the structure of the TRANSACTIONS table

describe   transactions;
select * from transactions limit 10;
SELECT COUNT(*) from transactions;
-- Exploratory Data Analysis (EDA) and basic insights

-- How many transactions are there?

select count(*) AS TOTAL_TRANSACTIONS FROM TRANSACTIONS;

-- What is the total sales amount?
SELECT SUM(TOTAL_SPENT) AS TOTAL_SALES FROM TRANSACTIONS;

-- What are the best-selling products?
SELECT ITEM, COUNT(*) AS TIMES_SOLD
FROM TRANSACTIONS
group by  ITEM
ORDER BY TIMES_SOLD DESC
LIMIT 1

-- Which category generates the highest revenue?
SELECT category, sum(total_spent) as total_sold
from transactions
group by category
order by total_sold desc
limit 10;

-- What are the preferred payment methods?
Select payment_method,count(*) as count
from transactions
group by payment_method
order by count desc;

-- What is the average sales per month?
SELECT
 DATE_FORMAT(TRANSACTION_DATE, '%Y-%m') AS month, 
sum(total_spent) as total_sales
FROM Transactions
group by month
order by month;
 -- Monthly Average Quantity Sold
SELECT date_format(Transaction_Date, '%Y-%m') AS 'year_month',
       AVG(Quantity) AS Avg_Quantity_Sold
FROM transactions
GROUP BY DATE_FORMAT(Transaction_Date, '%Y-%m')
ORDER BY DATE_FORMAT(Transaction_Date, '%Y-%m');

SELECT Transaction_Date, Quantity FROM Transactions LIMIT 5;
