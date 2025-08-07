--sql Retail Sales Analysis-p1
CREATE DATABASE Project1;

--create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time	TIME,
customer_id	INT,
gender	VARCHAR(10),
age	INT,
category	varchar(15),
quantiy	INT,
price_per_unit	FLOAT,
cogs	FLOAT,
total_sale FLOAT
)


SELECT * 
FROM retail_sales
LIMIT 10;



SELECT COUNT (*)
FROM retail_sales


SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE customer_id IS NULL

SELECT * FROM retail_sales
WHERE gender IS NULL

SELECT * FROM retail_sales
WHERE age IS NULL

--data cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL	 
OR cogs IS NULL
OR total_sale IS NULL

DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL	 
OR cogs IS NULL
OR total_sale IS NULL

--data exploration

--how many sales we have?
SELECT COUNT(*) AS total_sales
FROM retail_sales 

--how many customers we have?
SELECT COUNT (customer_id) AS total_sales
FROM retail_sales

--how many unique customers we have?
SELECT COUNT (DISTINCT customer_id) AS total_sales
FROM retail_sales


--how many categories we have?
SELECT COUNT (DISTINCT category) AS total_sales
FROM retail_sales
--what were those categories?
SELECT DISTINCT category
FROM retail_sales



--data analysis & business key problems and answers

--Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05'

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category='Clothing'
AND TO_CHAR(sale_date,'YYYY-MM')='2022-11'
AND quantiy>=4

--Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,
SUM(total_sale) AS net_sales
FROM retail_sales
GROUP BY 1

----Write a SQL query to calculate the total sales (total_sale) for each category and total orders.
SELECT category,
SUM(total_sale) AS net_sales,
COUNT (*) AS total_orders
FROM retail_sales
GROUP BY 1

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category='Beauty'

--Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale>='1000'

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT category,
gender,
COUNT(*) AS total_trans
FROM retail_sales
GROUP BY 1,2
ORDER BY 1

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT EXTRACT (YEAR FROM sale_date) AS year,
EXTRACT (MONTH FROM sale_date) AS month,
AVG(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1,2
--ORDER BY 1,3 DESC

SELECT year,
month, 
avg_sale
FROM (
SELECT EXTRACT (YEAR FROM sale_date) AS year,
EXTRACT (MONTH FROM sale_date) AS month,
AVG(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1,2
) AS table1
WHERE rank=1
--to find out the best avg sale month from each year

--**Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT customer_id,
SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT category,
COUNT (DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY 1

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
SELECT EXTRACT (HOUR FROM CURRENT_TIME)

SELECT*,
CASE
WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'morning'
WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
ELSE 'evening'
END AS shift
FROM retail_sales

WITH hourly_sale
AS
(SELECT*,
CASE
WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'morning'
WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
ELSE 'evening'
END AS shift
FROM retail_sales)
SELECT shift,
COUNT(*) AS total_order
FROM hourly_sale
GROUP BY shift


--END OF PROJECT