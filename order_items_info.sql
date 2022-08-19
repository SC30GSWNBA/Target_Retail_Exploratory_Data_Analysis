select * from `target-retail-64862.target_retail.order_items`
limit 100;

select order_id, sum(price) as total_price from `target-retail-64862.target_retail.order_items`
group by order_id;

-- 112650 records in order_items table
select count(*) from `target-retail-64862.target_retail.order_items`;

-- 98666 distinct orders in order_items table
select count(distinct order_id) from `target-retail-64862.target_retail.order_items`;

-- No missing records in order_item_id column
select count(order_item_id) from `target-retail-64862.target_retail.order_items`;

-- Count of customers by number of orders placed (Insert Image)
select ord_item.total_items, count(*) as number_of_customers from
(select order_id, max(order_item_id) as total_items from `target-retail-64862.target_retail.order_items`
group by order_id) as ord_item
group by ord_item.total_items
order by ord_item.total_items;

-- 32951 distinct products in order_items table
select count(distinct product_id) from `target-retail-64862.target_retail.order_items`;

-- 3095 sellers in order_items table
select count(distinct seller_id) from `target-retail-64862.target_retail.order_items`;

-- Range of shipping order dates - 19-09-2016 to 09-04-2020
select max(shipping_limit_date), min(shipping_limit_date) from `target-retail-64862.target_retail.order_items`;

-- Number of orders by shipping_limit_date - [This will have to grouped as per week, month, year]
select shipping_limit_date, count(*) as orders from `target-retail-64862.target_retail.order_items`
group by shipping_limit_date
order by shipping_limit_date desc;

-- No missing records for price or freight_value column in order_items table
select * from `target-retail-64862.target_retail.order_items`
where price is null or freight_value is null;


-- Summary statistics of price in order_items table
select min(price) as min_price, max(price) as max_price, round(stddev(price),2) as stddev_price, round(avg(price),2) as mean_price, max(price)-min(price) as price_range from `target-retail-64862.target_retail.order_items`;


-- Summary statistics of freight_value in order_items table
select min(freight_value) as min_freight_value, max(freight_value) as max_freight_value, round(stddev(freight_value),2) as stddev_freight_value, round(avg(freight_value),2) as mean_freight_value, max(freight_value)-min(freight_value) as freight_value_range from `target-retail-64862.target_retail.order_items`;
