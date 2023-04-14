# Show unique nodes are there on the Data Bank system?
select  distinct node_id
from customer_nodes ;


# How many unique nodes are there on the Data Bank system?
select count(distinct node_id)
from customer_nodes ;


# How many customers are there ?
select count(distinct customer_id)
from customer_nodes ;


# How much total transactions amount made by each customer ?
select customer_id,sum(txn_amount)
from customer_transactions
group by customer_id
order by customer_id asc ;


# how much total amount according to transaction type ?
select txn_type ,sum(txn_amount) 
from customer_transactions
group by txn_type ;


# What is the count of each nodes per region?
select region_id,node_id, count(*) as nodes_count
from customer_nodes
group by region_id , node_id
order by region_id , node_id ;


# count of nodes per region
select region_id, count(node_id)
from customer_nodes
group by region_id 
order by region_id;


# How many customers are allocated to each region?
select r.region_name,n.region_id,count(distinct customer_id)
 from customer_nodes as n
 join regions as r
 on n.region_id = r.region_id
 group by n.region_id ;
 

# after How many days each customers reallocated to a different node?
select *,customer_id,timestampdiff(DAY , start_date , end_date) as 'days_customers_nodes_got_changed'
from customer_nodes 
group by customer_id;


# How many days on average are customers reallocated to a different node?
select * ,avg(timestampdiff(DAY , start_date , end_date)) as 'days_customers_nodes_got_changed'
from customer_nodes 
where end_date <> '9999-12-31';


# What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
#with cte1 as(select * ,timestampdiff(DAY , start_date , end_date) as 'days_customers_nodes_got_changed'
#from customer_nodes 
#where end_date <> '9999-12-31' 
#order by days_customers_nodes_got_changed asc ) ,
#cte2 as (select *,count(*) as 'number_of_days' from cte1 group by region_id )
#select *,(number_of_days + 1 ) /2 
#from cte2


# What is the unique count and total amount for each transaction type?
select txn_type , count(*) as count_of_transactions , sum(txn_amount) as total_transactions
from customer_transactions
group by txn_type ;


# What is the total deposit counts and amounts for all customers?
select * , count(*) as count_of_transactions , sum(txn_amount) as total_amount
from customer_transactions
where txn_type = 'deposit' ;


# What is the average total amounts for all customers?
select txn_type , count(*) as count_of_transactions , avg(txn_amount) as avg_total_amount
from customer_transactions
where txn_type = 'deposit' ;


# # What is the average total deposit counts and amounts for all customer?
with cte1 as(
select *, count(txn_type) as count_of_transactions, sum(txn_amount) as total_amount
from customer_transactions 
where txn_type='deposit'
group by customer_id ) 
select * , avg(total_amount) ,avg(count_of_transactions)
from cte1 ;


# For each month - how many Data Bank customers are there ?
select *, count(distinct customer_id) , month(txn_date)
from customer_transactions
group by month(txn_date)  ;
#having count(txn_type = 'deposit') = 1 and count(txn_type = 'purchase') = 1 or count(txn_type = 'withdrawl') = 1 


# What is the amount for each customer at the end of the month?
select customer_id, sum(txn_amount) as total_amount ,month(txn_date)
from customer_transactions
group by month(txn_date) , customer_id
order by customer_id ;


# total amount for all customers in each region
select r.region_name,c.txn_type, sum(c.txn_amount)
from customer_nodes as n
join regions as r
on n.region_id = r.region_id
join customer_transactions as c
on n.customer_id = c.customer_id
group by r.region_name,c.txn_type
order by r.region_name,c.txn_type ;


# How many times each customer made a deposit in each month
select *,month(txn_date) as months , count(*)
from customer_transactions
where txn_type = 'deposit'
group by months,customer_id ;


# Find out average purchase rate in the economy in different regions
select r.region_name , avg(txn_amount) as avg_purchase_rate
from customer_nodes as n
join regions as r
on n.region_id = r.region_id
join customer_transactions as c
on n.customer_id = c.customer_id
where txn_type = 'purchase'
group by r.region_name ;