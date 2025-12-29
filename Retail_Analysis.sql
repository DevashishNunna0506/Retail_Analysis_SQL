show databases;
create database retail_sales_db;
USE retail_sales_db;
#transactions_id	sale_date	sale_time	customer_id	gender	age	category	quantiy	price_per_unit	cogs	total_sale
#Step 1- Creation of database
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

#LOAD DATA LOCAL INFILE 'D:\Project_Data_Analysis\Retail_Sales_Analysis\SQL - Retail Sales Analysis.csv'
#INTO TABLE retail_analysis
#FIELDS TERMINATED BY ','
#LINES TERMINATED BY '\n'
#IGNORE 1 ROWS;

#Data Exploration:
#Q1> No of Records
select count(*) from retail_analysis;

#Q2> How many unique customers we have
select count(distinct(customer_id)) from retail_analysis;

#Q3 How many different categories we have
select  distinct category,count(*) as No_of_transaction from retail_analysis group by category;

#Data Analysis & Business Problems
#--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
#-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
#-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
#-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
#-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
#-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
#-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
#-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
#-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
#-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
 
# Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05 
select * from retail_analysis limit 2;
select * from retail_analysis where sale_date = '2022-11-05';

# Q2  Write a SQL query to retrieve all transactions where the category is 'Clothing' 
#and the quantity sold is more than 10 in the month of Nov-2022
select * from retail_analysis where category='Clothing' and quantiy>=4 and year(sale_date)=2022 and month(sale_date)=11;

# Q3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,count(*) as No_of_Transactions,sum(total_sale) as Total_Revenue from retail_analysis group by category order by Total_Revenue desc;

#Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select * from retail_analysis limit 2;
select round(avg(age),2) as Average_Age,category from retail_analysis where category='Beauty' group by category;

#Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_analysis where total_sale>1000;

#Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category,count(*) as Total_No_of_Transcation from retail_analysis group by category,gender order by category;

#Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from retail_analysis limit 3;
select * from(
select month(sale_date) as Month_Sale,year(sale_date) as Year_Sale,avg(total_sale) as Average_Sale,rank() over(partition by year(sale_date) order by avg(total_sale) desc) as ranks from retail_analysis group by month(sale_date),year(sale_date)) as derived_table
where ranks=1; #order by  year(sale_date),Average_Sale desc

#Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,sum(total_sale) as Total_Purchase_Power from retail_analysis group by customer_id order by Total_Purchase_Power desc Limit 5; 

#Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select count(distinct customer_id) as unique_customer_count,category from retail_analysis group by category;

#Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
select * from retail_analysis; 

select count(transactions_id) as No_of_Order_per_Shift,shift_time from(
select *,
CASE
	when hour(sale_time)<=12 then 'Morining'
    when hour(sale_time)>12 and hour(sale_time)<17 then 'Afternoon'
    else 'Evening'
END as shift_time
from retail_analysis)as derived_table3
group by shift_time;

select * from retail_analysis;
#Final Question Top customers that placed orders in the afternoon, with this information we can run message nor=tifications for discounts such that we can get more revenue

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

#----END of the Project-----