select * from plans;
select * from subscriptions;

/*How many customers has Foodie-Fi ever had?
What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
What is the number and percentage of customer plans after their initial free trial?
What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
How many customers have upgraded to an annual plan in 2020?
How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
How many customers downgraded from a pro monthly to a basic monthly plan in 2020? */

select * from subscriptions;
select * from plans;
---------------------------------------------------------------------------------------------------------------------------------------------------------------
# How many customers has Foodie-Fi ever had?
select count(distinct customer_id)
from subscriptions;
-----------------------------------------------------------------------------------------------------------
#What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
 Select month(start_date), count(distinct customer_id) monthly_distribution 
 from subscriptions s join plans p on s.plan_id = p.plan_id
 where s.plan_id = 0
 group by month(start_date);
 
---------------------------------------------------------------------------------------------------
# What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
select plan_id, count(1) as count_of_events 
from subscriptions
where year(start_date) >2020
group by plan_id ;
--------------------------------------------------------------------------------------------
# What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
with k as (select	count(distinct customer_id) as cx_count
#((select count( distinct customer_id) as churn  from subscriptions where plan_id = 4 )/( select count(distinct customer_id) as count from subscription)) as per
from subscriptions
where plan_id = 4)
select cx_count, (100*cx_count/(select count(distinct customer_id)  from subcription)) as per
from k
;
with k as (
Select plan_name, count(distinct s.customer_id) as Total_customer, sum(case when s.plan_id = 4 then 1 else 0 end) as churned_cx
From subscriptions s join plans p on p.plan_id =s.plan_id)
select plan_name, round(100*churned_cx/ Total_customer) as per_churn, churned_cx
from k
;
WITH counts_cte AS
  (SELECT plan_name,
          count(DISTINCT customer_id) AS distinct_customer_count,
          SUM(CASE
                  WHEN plan_id=4 THEN 1
                  ELSE 0
              END) AS churned_customer_count
   FROM subscriptions
   JOIN plans USING (plan_id))
SELECT *,
       round(100*(churned_customer_count/distinct_customer_count), 2) AS churn_percentage
FROM counts_cte;

select * from plans;
#TBD
---------------------------------------------------------------------------------------
#How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
 Select count(distinct customer_id) as Free_trial_Cx
 from subscriptions
 where plan_id = 0;
 
 -----------------------------------------------------------------------------------------
 # What is the number and percentage of customer plans after their initial free trial?
with k as (
select plan_id, customer_id, lead(plan_id)over(partition by customer_id order by start_date) as next_plan
from subscriptions)
select next_plan,count(*) as number_of_cs, round(100* count(*)/sum(count(*))over(),2) as per
from K 
where plan_id = 0 and next_plan is not null 
group by next_plan
order by number_of_cs
;
 ------------------------------------------------------------------------------------------------
 #What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
select plan_id,count(*) as cx_cnt , round(100*(count(*))/sum(count(*))over(),2) as per
from subscriptions
where start_date <='2020-12-31'
group by plan_id;

---------------------------------------------------------------------------------------------------
#How many customers have upgraded to an annual plan in 2020?
select * from subscriptions;
select * from plans;

Select count(*) as number_customer
from subscriptions
where year(start_date) = '2020' and plan_id = 3;

---------------------------------------------------------------------------------------------
#How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
with trial as
(Select * from subscriptions where plan_id=0),
annual  as ( select * from subscriptions where plan_id= 3)
select round(avg(datediff(trial.start_date,annual.start_date)),2) as avg_days
from trial inner join annual on trial.customer_id = annual.customer_id;

------------------------------------------------------------------------------------------------------
 #Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

 with trial as
(Select * from subscriptions where plan_id=0),
annual  as ( select * from subscriptions where plan_id= 3)
select count(annual.customer_id) as numb_cx,round(datediff(annual.start_date,trial.start_date)/30) as avg_days
from trial inner join annual on trial.customer_id = annual.customer_id
group by round(datediff(annual.start_date,trial.start_date)/30)
order by avg_days;
----------------------------------------------------------------------------------------------------
#How many customers downgraded from a pro monthly to a basic monthly plan in 2020? */

select * from plans;
with k as (Select *,lead(plan_id)over(partition by customer_id ) as next_plan
from subscriptions)
select count(*) as cnt
from k
where plan_id=2 and next_plan = 1
;
 
 
 
 
 
 
 
 
 












