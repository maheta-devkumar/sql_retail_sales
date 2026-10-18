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

-- COMMENT

SELECT * FROM RETAIL_SALES;

-- DATA HAS BEEN IMPORTED

SELECT * FROM RETAIL_SALES ORDER BY transactions_id LIMIT 10;

SELECT COUNT(transaction_id) FROM RETAIL_SALES;


ALTER TABLE RETAIL_SALES RENAME TO retail_sales;

select * from retail_sales limit 5;

select * from retail_sales where age is null order by transaction_id;
select * from retail_sales where quantity is null order by transactions_id;

alter table retail_sales
rename column quantiy to quantity;

alter table retail_sales
rename column transactions_id to transaction_id;

delete from retail_sales
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

-- exploratory analysis

-- how many sales do we have?
select count(*) as sales_count from retail_sales;

-- how many customers do we have?
select count(distinct customer_id) as customer_count from retail_sales;

-- list of all categories
select distinct category from retail_sales;



-- business analysis | businesss key problems and Answers



-- all the sales made on '2022-11-05'
select * from retail_sales where sale_date = '2022-11-05';

-- all transactions where category = 'clothing', quantity >= 10, date = 'nov-2022'
select * from retail_sales
where category = 'Clothing'
and
quantity >= 4
and
sale_date >= date '2022-11-01'
and
sale_date <= date '2022-12-01';

select * from retail_sales
where
to_char(sale_date, 'YYYY-MM') = '2022-11'
and 
quantity >= 4
and 
category = 'Clothing';

-- total sales by each category
select category, sum(total_sale) from retail_sales group by category;

-- average age of customer who buys from 'beauty' category.
select round(avg(age),2) from retail_sales where category = 'Beauty';

-- all transactions where total_sales > 1000
select * from retail_sales where total_sale > 1000;

--count transactions made by each gender in each category.
select category, gender, count(transaction_id) as transaction_count from retail_sales group by 1, 2 order by 1;

--avg sale each month
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

SELECT year, month, average_sale
FROM (
    SELECT
        extract(year from sale_date) as year,
        extract(month from sale_date) as month,
        ROUND(AVG(total_sale)::numeric, 2) AS average_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS sales_rank
    FROM retail_sales
    GROUP BY
        1,2
) AS t1
WHERE sales_rank = 1;

-- top 5 customer based on highest total_sale
select customer_id, sum(total_sale) as total_sale from retail_sales
group by 1 order by 2 desc limit 5;

-- count of unique customers in each category
select category, count(distinct customer_id) as customer_count from retail_sales
group by 1;

-- create new column "shift" with values "morning" if hour < 12, "Afternoon" if > 12 and < 17
-- and evening for > 17. then total_sale for each shift.

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