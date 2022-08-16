select * from `target-retail-64862.target_retail.customers`;

-- 99441 records in customers table
select count(*) from `target-retail-64862.target_retail.customers`;

-- 99441 customer records in customers table
select count(distinct customer_id) from `target-retail-64862.target_retail.customers`;

-- 4119 distinct cities in customers table
select count(distinct(customer_city)) from `target-retail-64862.target_retail.customers`;

-- 27 distinct states in customers table
select count(distinct(customer_state)) from `target-retail-64862.target_retail.customers`;

-- SP state has the highest and RR has the least number of customers
select customer_state, count(*) as state_count from `target-retail-64862.target_retail.customers`
group by customer_state
order by count(*) desc;

-- sao paulo city has the highest number of customers
select customer_city, count(*) as city_count from `target-retail-64862.target_retail.customers`
group by customer_city
order by count(*) desc;

-- MG state has the highest and RR has the least number of cities in customers table
select customer_state, count(distinct customer_city) as city_count from `target-retail-64862.target_retail.customers`
group by customer_state
order by count(distinct customer_city) desc;