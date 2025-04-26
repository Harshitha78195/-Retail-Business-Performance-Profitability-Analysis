CREATE TABLE retail_data (
    Row_ID SERIAL PRIMARY KEY,
    Order_ID VARCHAR(50),
    Order_Date TEXT,    -- Use TEXT first
    Ship_Date TEXT,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(255),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(100),
    State VARCHAR(100),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(50),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(255),
    Sales FLOAT,
    Quantity INT,
    Discount FLOAT,
    Profit FLOAT
);

--Import Data
COPY retail_data (Row_ID, Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Customer_Name, Segment,
                  Country, City, State, Postal_Code, Region, Product_ID, Category, Sub_Category, Product_Name,
                  Sales, Quantity, Discount, Profit)
FROM 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/PostgreSQL 16/Sales.csv' 
WITH (FORMAT csv, HEADER, DELIMITER ',', QUOTE '"', ENCODING 'WIN1252');


-- Clean Missing / Null Records

DELETE FROM retail_data
WHERE 
    Order_ID IS NULL
    OR Product_ID IS NULL
    OR Sales IS NULL
    OR Profit IS NULL
    OR Category IS NULL
    OR Sub_Category IS NULL;


--Profit Margins by Category
SELECT 
    Category,
    ROUND((SUM(Profit)::numeric / NULLIF(SUM(Sales), 0)::numeric) * 100, 2) AS Profit_Margin_Percentage
FROM retail_data
GROUP BY Category
ORDER BY Profit_Margin_Percentage DESC;

--Profit Margins by Sub-Category

SELECT 
    Category,
    Sub_Category,
    ROUND((SUM(Profit)::numeric / NULLIF(SUM(Sales), 0)::numeric) * 100, 2) AS Profit_Margin_Percentage
FROM retail_data
GROUP BY Category, Sub_Category
ORDER BY Category, Profit_Margin_Percentage DESC;


--Top 10 Products by Total Profit
SELECT 
    Product_Name,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM retail_data
GROUP BY Product_Name
ORDER BY Total_Profit DESC
LIMIT 10;


--Last 10 Sub-Categories by Profit Margin

SELECT 
    Category,
    Sub_Category,
    ROUND((SUM(Profit)::numeric / NULLIF(SUM(Sales), 0)::numeric) * 100, 2) AS Profit_Margin_Percentage,
    SUM(Profit) AS Total_Profit
FROM retail_data
GROUP BY Category, Sub_Category
ORDER BY Profit_Margin_Percentage ASC
LIMIT 10;







