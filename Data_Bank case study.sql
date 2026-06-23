#--Case study Case Study #4 - Data Bank
#--URL==>https://8weeksqlchallenge.com/case-study-4/

/*---------------A. Customer Nodes Exploration-----------------------------------
How many unique nodes are there on the Data Bank system?
What is the number of nodes per region?
How many customers are allocated to each region?
How many days on average are customers reallocated to a different node?
What is the median, 80th and 95th percentile for this same reallocation days metric for each region?*/
------------------------------------------------------------------------------------------------------------------

#How many unique nodes are there on the Data Bank system?

Select distinct Node_id from customer_nodes;

---------------------------------------------------------------
#What is the number of nodes per region?
Select region_id, count(distinct node_id) No_of_nodes from customer_nodes
Group by region_id;

-------------------------------------------------------------
#How many customers are allocated to each region?
Select region_id, count(distinct customer_id) as No_of_cx 
from Customer_nodes
Group by region_id;

----------------------------------------------------

Select * from customer_transactions;
Select * from regions;
Select * from Customer_nodes;
----------------------------------------------------------
/*What is the unique count and total amount for each transaction type?
What is the average total historical deposit counts and amounts for all customers?
For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
What is the closing balance for each customer at the end of the month?
What is the percentage of customers who increase their closing balance by more than 5%?*/

------------------------------------------------------------------------------
#What is the unique count and total amount for each transaction type?
Select * from customer_transactions;

Select txn_type, count(1) as unique_count, sum(txn_amount) amt
from customer_transactions
group by txn_type;

----------------------------------------------------------
#What is the average total historical deposit counts and amounts for all customers?
Select customer_id, avg(txn_amount) as avg_amt, count(1) as avg_deposite 
from customer_transactions
where txn_type = 'Deposit'
group by customer_id;

-----------------------------------------------------------------
# For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
with k as (
Select customer_id, month(txn_date) txn_Month, sum(if( txn_type = 'deposit',1, 0)) as Deposit_count, 
sum(if( txn_type = 'withdrawal', 1, 0)) as withdrawal_count,sum(if( txn_type = 'purchase', 1, 0)) as purchase_count
from customer_transactions
group by customer_id,month(txn_date))
select * from k where Deposit_count > 1 and (withdrawal_count >= 1 or purchase_count >=1 )
;
-------------------------------------------------------------------------------------------
#What is the closing balance for each customer at the end of the month?
with k as (
select customer_id,txn_date, sum(case when txn_type then txn_amount else -txn_amount end) as balance from customer_transactions
group by customer_id,txn_date)
select customer_id, Month(txn_date) as  month_numb, sum(balance) over (partition by customer_id order by txn_date) as total_balance
from k
group by customer_id, Month(txn_date), txn_date
;

------------------------------------------------------------------------------------------------
#What is the percentage of customers who increase their closing balance by more than 5%

Select *
 from customer_transactions
where customer_id = 429 and Month(txn_date) = 2
order by txn_date desc;

with balance_snapshot as (
Select customer_id, txn_date, first_value(txn_amount) over (partition by customer_id order by txn_date asc) initial_balance,
first_value(txn_amount) over (partition by customer_id order by txn_date desc) Final_balance
 from customer_transactions
where customer_id = 429 and Month(txn_date) = 2)
Select * from balance_snapshot
;

















