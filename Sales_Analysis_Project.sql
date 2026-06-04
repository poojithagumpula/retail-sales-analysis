USE ourproject;

-- Step 1: Disable safe update mode
SET sql_safe_updates = 0;

-- Step 2: Convert the date format (note uppercase %Y)
UPDATE sales
SET purchase_date = STR_TO_DATE(purchase_date, '%d-%m-%Y');

-- Step 3: Verify it worked
SELECT purchase_date FROM sales LIMIT 10;
ALTER TABLE sales
MODIFY COLUMN purchase_date DATE;

-- change to time format
UPDATE sales
SET time_of_purchase = STR_TO_DATE(time_of_purchase, '%H:%i:%S');

ALTER TABLE sales
modify time_of_purchase TIME;

--  WHAT ARE THE TOP 5 MOST SELLING PRODUCTS by quantity? --

select
    product_name,
      sum(quantity) as total_quantity_sold
from sales
where status = 'delivered'
group by product_name
order by total_quantity_sold DESC
limit 5;
  
ALTER TABLE sales
RENAME COLUMN quantiy TO quantity;  

-- 2 which products are most frequently canelled?--
select
      product_name,
      count(*) as total_Cancelled
from sales
where status = 'cancelled'
group by product_name
order by total_Cancelled DESC
limit 10;

-- 3 what times of the day has the highest number of purchases?--
select
     case
     when hour(time_of_purchase) between 6 and 11 then 'Morning'
     when hour(time_of_purchase) between 12 and 17 then 'Afternoon'
     when hour(time_of_purchase) between 18 and 23 then 'Evening'
     else 'Night'
     end as time_of_day,
     count(*) as total_order
     from sales
     group by time_of_day
     order by total_order DESC;
     
-- 4 who are the top 5 highest spending customers?--

select
	 customer_id,
     customer_name,
     sum(quantity*price) as total_spendings_by_customer
from sales
where status = 'Delivered'
group by customer_id, customer_name
order by total_spendings_by_customer DESC
LIMIT 5;

-- 5  which product categories generate the highest revenue?--

select
     product_category,
     sum(quantity*price) as revenue
     
from sales
where status = 'Delivered'
group by product_category
order by revenue DESC
LIMIT 1;

-- 6 what is the return/cancellation rate per product category?--
select
     product_category,
     count(*) as total_order,
     sum(status = 'returned') as returned_orders,
     sum(status = 'cancelled') as cancelled_orders,
     sum(status = 'returned')/count(*) as returned_rate,
     sum(status = 'cancelled')/count(*) as cancelled_rate
from sales
group by product_category;

-- 7 what is the preferred payment mode?--
select
      payment_mode,
      count(*) as total_count
from sales
group by payment_mode
order by total_count desc;
     

 -- 8 how does age group affected purchasing behaviour?--
 select
     case
     when customer_age between 18 and 25 then '18-25'
     when customer_age between 26 and 35 then '26-35'
     when customer_age between 36 and 50 then '36-50'
     else '51+'
     end as age_group,
     
   sum(quantity*price) as total_purchase_by_age
 from sales
 group by age_group
 order by total_purchase_by_age DESC;
 
 -- 9 WHAT IS THE MONTHLY SALES TREND?--

select
    date_format(purchase_date,'%Y-%M') as monthly_purchase,
    sum(quantity*price) as total_sales,
	sum(quantity)
from sales
group by monthly_purchase
order by monthly_purchase;

-- 10 are certain genders buying more specific product categories?--

select
     gender,
     product_category,
     count(product_category) as total_purchase
from sales
group by gender,product_category
order by total_purchase DESC;







      
