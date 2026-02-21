-- Select Query
Select * from customer_shopping_behavior limit 20;

-- Total revenue by gender.
select gender, sum(purchase_amount_usd) as revenue
from customer_shopping_behavior
group by gender;


-- Customers that used discount but still spent more than the average purchase amount.
select customer_id, purchase_amount_usd 
from customer_shopping_behavior
where discount_applied = 'Yes' and 
purchase_amount_usd >= (
	select AVG(purchase_amount_usd) 
	from customer_shopping_behavior
	);


-- Top 5 products with the highest average review rating.
select item_purchased, 
ROUND(AVG(review_rating::numeric), 2) as "Avarage Product Rating"
from customer_shopping_behavior
group by item_purchased
order by AVG(review_rating) desc
limit 5;

-- Average Purchase amount between Standard and Express Shipping. 
select shipping_type,
ROUND(AVG(purchase_amount_usd), 2)
from customer_shopping_behavior
where shipping_type in ('Standard', 'Express')
group by shipping_type;

-- average spend and total revenue, between subscribers and non-subscribers.
select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount_usd), 2) as avg_spend,
ROUND(SUM(purchase_amount_usd), 2) as total_revenue
from customer_shopping_behavior
group by subscription_status
order by total_revenue, avg_spend desc;

-- Top 5 products that have the highest percentage of purchases with discounts applied.
SELECT item_purchased,
ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) as discount_rate
from customer_shopping_behavior
group by item_purchased
order by discount_rate desc
limit 5;


-- Segment customers into New, Returning, and Loyal based on their total 
-- number of previous purchases, and show the count of each segment. 
with customer_type as (
select customer_id, previous_purchases,
CASE 
	WHEN previous_purchases = 1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
	ELSE 'loyal'
	END AS customer_segment
from customer_shopping_behavior
)
select customer_segment, COUNT(*) as number_of_customers from customer_type
group by customer_segment;


-- Top 3 most purchased products within each category.
with item_counts as (
select category,
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over (
	partition by category 
	order by count(customer_id) DESC
) as item_rank
from customer_shopping_behavior
group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;
 
--Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from customer_shopping_behavior
where previous_purchases > 5
group by subscription_status;

--Q10. What is the revenue contribution of each age group? 
select age_group,
SUM(purchase_amount_usd) as total_revenue
from customer_shopping_behavior
group by age_group
order by total_revenue desc;

