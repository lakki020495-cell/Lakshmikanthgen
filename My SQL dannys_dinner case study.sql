----------------------------------
-- CASE STUDY #1: DANNY'S DINER --
----------------------------------

-- Author: Manaswi Kamila
-- Date: 18/04/2022 
-- Tool used: MySQL Server


 
CREATE database dannys_diner;
use  dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1), 
  order_date DATE, 
  product_id INTEGER
);

INSERT INTO sales (
  customer_id, order_date, product_id
) 
VALUES 
  ('A', '2021-01-01', '1'), 
  ('A', '2021-01-01', '2'), 
  ('A', '2021-01-07', '2'), 
  ('A', '2021-01-10', '3'), 
  ('A', '2021-01-11', '3'), 
  ('A', '2021-01-11', '3'), 
  ('B', '2021-01-01', '2'), 
  ('B', '2021-01-02', '2'), 
  ('B', '2021-01-04', '1'), 
  ('B', '2021-01-11', '1'), 
  ('B', '2021-01-16', '3'), 
  ('B', '2021-02-01', '3'), 
  ('C', '2021-01-01', '3'), 
  ('C', '2021-01-01', '3'), 
  ('C', '2021-01-07', '3');

CREATE TABLE menu (
  product_id INTEGER, 
  product_name VARCHAR(5), 
  price INTEGER
);

INSERT INTO menu (product_id, product_name, price) 
VALUES 
  (1, 'sushi', 10), 
  (2, 'curry', 15), 
  (3, 'ramen', 12);


CREATE TABLE members (
  customer_id VARCHAR(1), 
  join_date DATE
);

INSERT INTO members (customer_id, join_date) 
VALUES 
  ('A', '2021-01-07'), 
  ('B', '2021-01-09');
  
  ---------------------------------------------------------------------------------
  /*--
--What is the total amount each customer spent at the restaurant?
--How many days has each customer visited the restaurant?
--What was the first item from the menu purchased by each customer?
--What is the most purchased item on the menu and how many times was it purchased by all customers?
---Which item was the most popular for each customer?
--Which item was purchased first by the customer after they became a member?
--Which item was purchased just before the customer became a member?
--What is the total items and amount spent for each member before they became a member?
--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
--In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
how many points do customer A and B have at the end of January?**/

#What is the total amount each customer spent at the restaurant?
select * from sales;
select * from menu;
select * from members;

select  distinct s.customer_id, sum(price) total_spent
from sales s join menu m on s.product_id = m.product_id
Group by s.customer_id;
-------------------------------------------------------------------------------------------
#  How many days has each customer visited the restaurant?
select customer_id, count(distinct order_date) as number_of_days
 from sales
 group by customer_id;
--------------------------------------------------------------------------------------------
#--What was the first item from the menu purchased by each customer?
with k as (
select customer_id, row_number() over(partition by customer_id order by order_date asc) as raw_numb, order_date, product_name
from sales s join menu m on s.product_id= m.product_id)
select * from k where raw_numb = 1
;
--------------------------------------------------------------------------------------
# --What is the most purchased item on the menu and how many times was it purchased by all customers?
select product_id, count(*) as cnt
from sales
group by product_id
order by cnt desc
limit 1;

-------------------------------------------------------------------------------------------
# If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
with k as (
Select customer_id, case when m.product_name = 'sushi' then m.price*20 else m.price*10 end as  points 
From Sales s join menu m on s.product_id = m.product_id)
select customer_id, sum(points) as total_points 
from k 
group by customer_id;
------------------------------------------------------------------------------------------------------
# In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
# not just sushi - how many points do customer A and B have at the end of January?

Select s.customer_id,
sum(case when s.order_date between mm.join_date and date_add(mm.join_date, interval 6 Day) then m.price*20 
when m.product_name = 'sushi' then m.price*20 else m.price *10 end) as points 
From Sales s join menu m on s.product_id = m.product_id join members mm on s.customer_id = mm.customer_id 
group by s.customer_id;
 














