# Retail Sales Analysis | PostgreSQL

## Project Overview

I built this project to practice SQL and explore how retail sales data can be used to answer business questions.

Using PostgreSQL, I worked with a retail sales dataset to perform data exploration, check for missing values, clean the data, and analyze sales patterns, customer behavior, and product categories.

This was one of my hands-on projects to strengthen my SQL skills and gain practical experience working with data.

## Tools & Technologies

- **Database:** PostgreSQL
- **SQL Editor:** pgAdmin 4
- **Skills:** Data Cleaning, Exploratory Data Analysis (EDA), Aggregations, Filtering, Joins and Subqueries, Window Functions, CTEs, Date and Time Functions

## Project Workflow

### 1. Database Setup

I created a database named `db1` and a table named `retail_sales` to store the dataset.

The table contains information such as transaction IDs, sale dates and times, customer details, product categories, quantities, prices, cost of goods sold, and total sales.

```sql
CREATE DATABASE db1;
```

I then created the `retail_sales` table with appropriate columns and data types for the dataset.

```sql
DROP TABLE IF EXISTS RETAIL_SALES;
CREATE TABLE RETAIL_SALES(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(6),
	age	INT,
	category VARCHAR(11),	
	quantiy INT,
	price_per_unit FLOAT,	
	cogs FLOAT,
	total_sale FLOAT
)
```

### 2. Data Exploration & Cleaning

Before starting the analysis, I explored the dataset to understand its structure and identify potential data quality issues.

I used SQL queries to:

- Count the total number of records.
- Find the number of unique customers.
- Identify the available product categories.
- Check for missing values across relevant columns.
- Remove records containing missing values in the selected fields.

Example:

```sql
SELECT * FROM RETAIL_SALES ORDER BY transaction_id LIMIT 10;

SELECT COUNT(transaction_id) FROM RETAIL_SALES;

select * from retail_sales limit 5;
```

I also checked for NULL values before removing incomplete records.

```sql
select * from retail_sales
where
transaction_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

```

After reviewing the records, I used a `DELETE` statement with the same conditions to remove incomplete entries.

### 3. SQL Analysis

I wrote SQL queries to answer ten business questions using the retail sales data.

#### 1. Sales on a Specific Date

I retrieved all transactions recorded on November 5, 2022.

```sql
select * from retail_sales where sale_date = '2022-11-05';
```

#### 2. Clothing Sales in November 2022

I filtered clothing transactions from November 2022 where the quantity sold was at least four units.

```sql
select * from retail_sales
where category = 'Clothing'
and
quantity >= 4
and
sale_date >= date '2022-11-01'
and
sale_date <= date '2022-12-01';
```

#### 3. Sales Performance by Category

I calculated total sales for each product category.

```sql
select category, sum(total_sale) from retail_sales group by category;
```

#### 4. Average Customer Age in the Beauty Category

I calculated the average age of customers who purchased beauty products.

```sql
select round(avg(age),2) from retail_sales where category = 'Beauty';
```

#### 5. High-Value Transactions

I identified transactions where the total sale amount exceeded 1,000.

```sql
select * from retail_sales where total_sale > 1000;
```

#### 6. Transactions by Gender and Category

I grouped transactions by product category and gender to compare transaction counts across these groups.

```sql
select category, gender, count(transaction_id) as transaction_count
from retail_sales
group by 1, 2 order by 1;
```

#### 7. Best-Selling Month in Each Year

I calculated the average sale for each month and used the `RANK()` window function to identify the month or months with the highest average sale in each year.

```sql
select year, month, average_sale from(
	select extract(year from sale_date) as year,
		   extract(month from sale_date) as month,
	   	   round(avg(total_sale)::numeric,2) as average_sale,
	   	   rank() over(
			  partition by extract(year from sale_date) order by avg(total_sale) desc
		   ) as rank
	   from retail_sales group by 1,2
) as t1
where rank = 1;
```

#### 8. Top Five Customers by Total Sales

I calculated total sales for each customer and ranked them by spending to identify the five highest-spending customers.

```sql
select customer_id, sum(total_sale) as total_sale from retail_sales
group by 1 order by 2 desc limit 5;
```

#### 9. Unique Customers by Category

I counted the distinct customers who purchased products in each category.

```sql
select category, count(distinct customer_id) as customer_count
from retail_sales
group by 1;
```

#### 10. Orders by Time of Day

I used a Common Table Expression (CTE) and a `CASE` expression to classify transactions into Morning, Afternoon, and Evening shifts. I then counted the orders in each shift.

```sql
with routine_sale as
(
	select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
	from retail_sales
) 
select shift, count(total_sale) as total_sale from routine_sale
group by 1;
```

## Key Takeaways

Through this project, I practised using SQL to investigate retail sales data and answer business-oriented questions.

The main areas I explored were:

- **Sales performance:** Comparing total sales and transaction counts across product categories.
- **Customer behavior:** Examining customer demographics and identifying high-spending customers.
- **Sales trends:** Finding months with the highest average sales within each year.
- **Transaction patterns:** Analyzing purchases by gender, product category, and time of day.
- **Data quality:** Checking for missing values before performing the analysis.
- **Advanced SQL:** Applying aggregate functions, subqueries, window functions, CTEs, and conditional logic.

## What I Learned

This project gave me practical experience writing SQL queries beyond basic `SELECT` statements. I became more comfortable combining multiple SQL concepts to solve specific analytical problems.

I also learned how window functions such as `RANK()` can help compare results within groups, and how date and time functions can be used to uncover patterns in transaction data.

## Project Files

- `README.md` — Project overview, workflow, and analysis queries.
- `database_setup.sql` — Database and table creation scripts, along with data import instructions where applicable.
- `analysis_queries.sql` — SQL queries used for the analysis.

*The filenames above describe the intended project structure; I will include the corresponding files in the repository.*

## Author

**Dev Mehta**

This project is part of my learning journey in data analytics. I am building practical skills in SQL, Excel, Python, and data analysis through hands-on projects.

[GitHub Profile](https://github.com/maheta-devkumar)
