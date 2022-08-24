-- Top 5 States with highest average freight value - replacing nulls with median value 17.09 - CONSIDERING NULLS
select cust.customer_state, avg(coalesce(oi.freight_value,17.09)) as mean_freight from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
left join `target-retail-64862.target_retail.order_items` oi on oi.order_id = ord.order_id
group by cust.customer_state
order by avg(coalesce(oi.freight_value,17.09)) desc
limit 5;

-- Top 5 States with least average freight value - replacing nulls with median value 17.09 - - CONSIDERING NULLS
select cust.customer_state, avg(coalesce(oi.freight_value,17.09)) as mean_freight from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
left join `target-retail-64862.target_retail.order_items` oi on oi.order_id = ord.order_id
group by cust.customer_state
order by avg(coalesce(oi.freight_value,17.09))
limit 5;


-- Top 5 States with highest average freight value - replacing nulls with median value 17.17 - - WITHOUT CONSIDERING NULLS
select cust.customer_state, avg(coalesce(oi.freight_value,17.17)) as mean_freight from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
left join `target-retail-64862.target_retail.order_items` oi on oi.order_id = ord.order_id
group by cust.customer_state
order by avg(coalesce(oi.freight_value,17.17)) desc
limit 5;

-- Top 5 States with least average freight value - replacing nulls with median value 17.17 - - WITHOUT CONSIDERING NULLS
select cust.customer_state, avg(coalesce(oi.freight_value,17.17)) as mean_freight from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
left join `target-retail-64862.target_retail.order_items` oi on oi.order_id = ord.order_id
group by cust.customer_state
order by avg(coalesce(oi.freight_value,17.17))
limit 5;


