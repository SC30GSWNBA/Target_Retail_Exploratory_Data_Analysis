-- Impact on Economy: Analyze the money movemented by e-commerce by looking at order prices, freight and others.

-- Get % increase in cost of orders from 2017 to 2018 (include months between Jan to Aug only)

select ord.order_id, ord.order_purchase_timestamp, ord_it.order_item_id, ord_it.price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
order by ord.order_id;

select ord.order_id, max(ord.order_purchase_timestamp), sum(ord_it.price) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
group by ord.order_id;

select ord.order_id, min(coalesce(ord_it.price, 0)) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where ord.order_id in ('0010dedd556712d7bb69a19cb7bbd37a','00a500bc03bc4ec968e574c2553bed4b','00b1cb0320190ca0daa2c88b35206009','00bca4adac549020c1273714d04d0208','00d0ffd14774da775ac832ba8520510f','00daac8efd71674d62356c2a306d1e4c')
group by ord.order_id;


select ord.order_id, sum(coalesce(ord_it.price, 0)) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
group by ord.order_id;

-- Median value is 85 considering nulls
select bracket.ntile_price, min(bracket.price) as min_price, max(bracket.price) as max_price, max(bracket.price)-min(bracket.price) as price_range from
(select price_items.order_id, price_items.price, ntile(4) over (order by price_items.price) as ntile_price from
(select ord.order_id, sum(ord_it.price) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
group by ord.order_id) as price_items) as bracket
group by bracket.ntile_price
order by bracket.ntile_price;

-- Median value is 86.9 ~ 87 considering not nulls
select 
case
    when bracket.ntile_price = 1 then '1st_Quartile'
    when bracket.ntile_price = 2 then '2nd_Quartile'
    when bracket.ntile_price = 3 then '3rd_Quartile'
    when bracket.ntile_price = 4 then '4th_Quartile'
    else ''
end as price_quartile,
bracket.ntile_price, min(bracket.price) as min_price, max(bracket.price) as max_price, max(bracket.price)-min(bracket.price) as price_range from
(select price_items.order_id, price_items.price, ntile(4) over (order by price_items.price) as ntile_price from
(select ord.order_id, sum(ord_it.price) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where ord_it.price is not null
group by ord.order_id) as price_items) as bracket
group by bracket.ntile_price
order by bracket.ntile_price;

select 
case
    when bracket.ntile_price = 1 then '1st_Quartile(Q1)'
    when bracket.ntile_price = 2 then '2nd_Quartile(Q2)'
    when bracket.ntile_price = 3 then '3rd_Quartile(Q3)'
    when bracket.ntile_price = 4 then '4th_Quartile(Q4)'
    else ''
end as price_quartile,
min(bracket.price) as min_price, max(bracket.price) as max_price, round(max(bracket.price)-min(bracket.price),2) as price_range from
(select price_items.order_id, price_items.price, ntile(4) over (order by price_items.price) as ntile_price from
(select ord.order_id, sum(ord_it.price) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where ord_it.price is not null
group by ord.order_id) as price_items) as bracket
group by bracket.ntile_price
order by bracket.ntile_price;


-- Replacing null price values with median value 85
select ord.order_id, max(FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp)) as order_purchase_date, sum(coalesce(ord_it.price, 85)) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) between '2017-01-01' AND '2018-08-31'
group by ord.order_id;

-- Replacing null price values with median value 87
select ord.order_id, max(FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp)) as order_purchase_date, sum(coalesce(ord_it.price, 87)) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) between '2017-01-01' AND '2018-08-31'
group by ord.order_id;

select ord.order_id, max(FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp)) as order_purchase_date, max(EXTRACT(MONTH from ord.order_purchase_timestamp)) as month, max(EXTRACT(YEAR from ord.order_purchase_timestamp)) as year, sum(coalesce(ord_it.price, 85)) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) between '2017-01-01' AND '2018-08-31'
group by ord.order_id;

--Considering Median value as 85
select cost_of_orders.year, cost_of_orders.month, avg(cost_of_orders.price) as avg_price_per_month, sum(cost_of_orders.price) as sum_price_per_month from
(select ord.order_id, max(FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp)) as order_purchase_date, max(EXTRACT(MONTH from ord.order_purchase_timestamp)) as month, max(EXTRACT(YEAR from ord.order_purchase_timestamp)) as year, sum(coalesce(ord_it.price, 85)) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) between '2017-01-01' AND '2018-08-31'
group by ord.order_id) as cost_of_orders
group by cost_of_orders.year, cost_of_orders.month
order by cost_of_orders.year, cost_of_orders.month;



--Considering Median value as 87
select cost_of_orders.year, cost_of_orders.month, round(avg(cost_of_orders.price),2) as avg_price_per_month, round(sum(cost_of_orders.price),2) as sum_price_per_month from
(select ord.order_id, max(FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp)) as order_purchase_date, max(EXTRACT(MONTH from ord.order_purchase_timestamp)) as month, max(EXTRACT(YEAR from ord.order_purchase_timestamp)) as year, sum(coalesce(ord_it.price, 87)) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) between '2017-01-01' AND '2018-08-31'
group by ord.order_id) as cost_of_orders
group by cost_of_orders.year, cost_of_orders.month
order by cost_of_orders.year, cost_of_orders.month;


select cost_of_orders.order_purchase_date, cost_of_orders.price as price from
(select FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) as order_purchase_date, sum(coalesce(ord_it.price, 87)) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) between '2017-01-01' AND '2018-08-31'
group by ord.order_id, FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp)) as cost_of_orders;


--Finding mean price : 137.75 without null

select avg(price_items.price) from
(select ord.order_id, sum(ord_it.price) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where ord_it.price is not null
group by ord.order_id) as price_items;


--Finding mean price : 137.75 with null

select avg(price_items.price) from
(select ord.order_id, sum(ord_it.price) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
group by ord.order_id) as price_items;

-- Distribution IRQ = 149.9 - 45.9 = 104. So anything beyond = Q3 + 1.5 * IQR is an outlier = 149.9 + 1.5 * 104 = 149.9 + 156 = 305.9
select bracket.ntile_price, min(bracket.price) as min_price, max(bracket.price) as max_price, max(bracket.price)-min(bracket.price) as price_range from
(select price_items.order_id, price_items.price, ntile(4) over (order by price_items.price) as ntile_price from
(select ord.order_id, sum(ord_it.price) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where ord_it.price is not null
group by ord.order_id) as price_items) as bracket
group by bracket.ntile_price
order by bracket.ntile_price;




-- Outliers detection : 7913 values have price more than 305.9
select ord.order_id, sum(ord_it.price) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where ord_it.price is not null
group by ord.order_id
having sum(ord_it.price) > 305.9;

select count(*) from
(select ord.order_id, sum(ord_it.price) as price from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where ord_it.price is not null
group by ord.order_id
having sum(ord_it.price) > 305.9);

