select * from `target-retail-64862.target_retail.orders`;

-- 99441 records in orders table
select count(*) from `target-retail-64862.target_retail.orders`;

-- 99441 customer records in orders table
select count(distinct customer_id) from `target-retail-64862.target_retail.orders`;

-- 99441 order_ids records in orders table
select count(distinct order_id) from `target-retail-64862.target_retail.orders`;

-- count of order status in orders table
select order_status, count(*) as order_status_count from `target-retail-64862.target_retail.orders`
group by order_status
order by count(*) desc;

-- All the records have order status associated with it
select count(order_status) from `target-retail-64862.target_retail.orders`;

-- There are 8 Distinct order status across orders table
select distinct(order_status) from `target-retail-64862.target_retail.orders`;

-- Purchase Dates between - 4th Sep 2016 to 17th Oct 2018
select min(order_purchase_timestamp) as first_order_date, max(order_purchase_timestamp) as latest_order_date from `target-retail-64862.target_retail.orders`;

-- Missing Purchase Date:
select order_purchase_timestamp from `target-retail-64862.target_retail.orders`
where order_purchase_timestamp is null;


-- How many of the delivered orders are late
select order_delivered_customer_date > order_estimated_delivery_date as IsLate, count(*) as count_of_orders from `target-retail-64862.target_retail.orders`
where order_status = 'delivered'
group by order_delivered_customer_date > order_estimated_delivery_date;
