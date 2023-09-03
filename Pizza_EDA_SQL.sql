use pizza_sales;

select * from order_details;
select * from orders;
select * from pizzas;
select * from pizza_types;

alter table orders
modify date date;

alter table orders
modify time time;

create view pizza_details as 
select p.pizza_id,p.pizza_type_id,pt.name,pt.category, p.size,p.price,pt.ingredients
from pizzas p
join pizza_types pt
on pt.pizza_type_id=p.pizza_type_id;

select * from pizza_details; 

-- total revenue
select round(sum(od.quantity*p.price),2) as total_revenue
from order_details od
join pizza_details as p
on od.pizza_id=p.pizza_id;

-- total no. of pizzas sold
select sum(od.quantity) as pizzas_sold
from order_details od;

-- total orders
select count(distinct(order_id)) as total_orders
from order_details;

-- average order value
select round(sum(od.quantity*p.price)/ count(distinct(order_id)),2) as avg_order_value
from order_details od
join pizza_details as p
on od.pizza_id=p.pizza_id;

-- average number of pizzas per order
select round(sum(od.quantity)/count(distinct(order_id)),0) as avg_no_pizza_per_order
from order_details od;


-- total revenue and no of orders per category
select p.category,round(sum(od.quantity*p.price),0) as total_revenue, count(distinct(od.order_id)) as total_orders
from order_details od
join pizza_details as p
on od.pizza_id=p.pizza_id
group by p.category;

select *
from order_details od
join pizza_details as p
on od.pizza_id=p.pizza_id;

-- total revenue and no of orders per size
select p.size,round(sum(od.quantity*p.price),0) as total_revenue, count(distinct(od.order_id)) as total_orders
from order_details od
join pizza_details as p
on od.pizza_id=p.pizza_id
group by p.size;

-- hourly,daily and monthly trend in revenue of pizza

## Hourly Trend:
select
	case
		when hour(o.time) between 9 and 12 then 'Late Morning'
        when hour(o.time) between 12 and 15 then 'Lunch'
        when hour(o.time) between 15 and 18 then 'Mid Afternoon'
        when hour(o.time) between 18 and 21 then 'Dinner'
        when hour(o.time) between 21 and 23 then 'Late Night'
        else 'others'
        end as meal_time,count(distinct(od.order_id)) as total_orders
from order_details od
join orders o on o.order_id=od.order_id
group by meal_time
order by total_orders desc;

##  Weekly Trend:
select dayname(o.date) as Day_Name,count(distinct(od.order_id)) as total_orders	
from order_details od
join orders o on o.order_id=od.order_id
group by Day_Name
order by total_orders desc;

## Monthwise Trend :
select monthname(o.date) as Month_Name,count(distinct(od.order_id)) as total_orders	
from order_details od
join orders o on o.order_id=od.order_id
group by Month_Name
order by total_orders desc;
        
-- Most ordered Pizza
select p.name,p.size,count(od.order_id) as count_pizzas
from order_details od
join pizza_details p on p.pizza_id=od.pizza_id
group by p.name,p.size
order by count_pizzas desc
limit 1;

-- Top 5 pizzas by revenue
select p.name,round(sum(od.quantity*p.price),0) as Total_Revenue
from order_details od
join pizza_details p on p.pizza_id=od.pizza_id
group by p.name
order by Total_Revenue desc
limit 5;

-- Top 5 pizzas by sale
select p.name,sum(od.quantity) as pizzas_sold
from order_details od
join pizza_details p on p.pizza_id=od.pizza_id
group by p.name
order by pizzas_sold desc
limit 5;

-- Pizza Analysis
select name, price
from pizza_details
order by pricedesc
limit 1;

-- Top used ingredients
select  distinct ingredients from pizza_details;


