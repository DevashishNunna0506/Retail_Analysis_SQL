# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `retail_sales_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. 

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sales_db`.
- **Table Creation**: A table named `retail_analysis` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
create database retail_sales_db;
USE retail_sales_db;
#Step 1- Creation of database and table for storing the retail data
create table retail_analysis 
(
	transactions_id int primary key,
    sale_date date,	
    sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(15),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float
);
```


### 2. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select *
from retail_analysis
where sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select * from retail_analysis where category='Clothing' and quantiy>=4 and year(sale_date)=2022 and month(sale_date)=11;

```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category,count(*) as No_of_Transactions,sum(total_sale) as Total_Revenue from retail_analysis group by category order by Total_Revenue desc;

```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select round(avg(age),2) as Average_Age,category from retail_analysis where category='Beauty' group by category;

```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from retail_analysis where total_sale>1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select gender,category,count(*) as Total_No_of_Transcation from retail_analysis group by category,gender order by category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
select * from(
select month(sale_date) as Month_Sale,year(sale_date) as Year_Sale,avg(total_sale) as Average_Sale,rank() over(partition by year(sale_date) order by avg(total_sale) desc) as ranks from retail_analysis group by month(sale_date),year(sale_date)) as derived_table
where ranks=1;

```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select customer_id,sum(total_sale) as Total_Purchase_Power from retail_analysis group by customer_id order by Total_Purchase_Power desc Limit 5; 

```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select count(distinct customer_id) as unique_customer_count,category from retail_analysis group by category;

```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
select count(transactions_id) as No_of_Order_per_Shift,shift_time from(
select *,
CASE
	when hour(sale_time)<=12 then 'Morining'
    when hour(sale_time)>12 and hour(sale_time)<17 then 'Afternoon'
    else 'Evening'
END as shift_time
from retail_analysis)as derived_table3
group by shift_time;
```

11.**Top customers that placed orders in the afternoon, with this information we can run message nor=tifications for discounts such that we can get more revenue
**:
```sql
select count(*) as No_of_Orders_placed,Round(avg(total_sale),2) as Average_amount_spent_Daytime,customer_id,shift_time from(
select *,
CASE
	when hour(sale_time)<=12 then 'Morining'
    when hour(sale_time)>12 and hour(sale_time)<17 then 'Afternoon'
    else 'Evening'
END as shift_time
from retail_analysis) as derived_table_4
group by customer_id,shift_time
order by No_of_Orders_placed desc
limit 10
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Devashish Nunna

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
Note: Done this with support of najirh, Najir H.
