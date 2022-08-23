--Analysis on sales, freight and delivery time

--Calculate days between purchasing, delivering and estimated delivery

--Create columns:

--time_to_delivery = order_purchase_timestamp-order_delivered_customer_date

--diff_estimated_delivery = order_estimated_delivery_date-order_delivered_customer_date

select * from `target-retail-64862.target_retail.orders`
where order_delivered_customer_date is null;

select count(*) from `target-retail-64862.target_retail.orders`
where timestamp_diff(order_delivered_customer_date, order_estimated_delivery_date, day) > 0;


-- There are 2965 orders for which customer delivery date is missing. As delivery date is purely dependent on operational efficiency we need to treat these entries separately and see what could be good measure of time_to_delivery and diff_estimated_delivery based on entries where we have data for time_to_delivery and diff_estimated_delivery
select cust.customer_state, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) as ord_purch_ts, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_estimated_delivery_date) as ord_est_del_dt, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) as ord_del_cust_dt,
timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day) as time_to_delivery, 
timestamp_diff(order_delivered_customer_date, order_estimated_delivery_date, day) as diff_estimated_delivery from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) is null;

select count(*) from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) is null;

-- Avg delivery date is 12.09 ~ 12 days
select avg(timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day)) from `target-retail-64862.target_retail.orders`
where FORMAT_TIMESTAMP("%Y-%m-%d", order_delivered_customer_date) is not null;

-- Median delivery date is 10 days

select ntile_data.ntile_del_time, min(ntile_data.time_to_delivery) as min_del_time, max(ntile_data.time_to_delivery) as max_del_time, max(ntile_data.time_to_delivery)-min(ntile_data.time_to_delivery) as del_time_range from
(select date_data.customer_state, date_data.time_to_delivery,
ntile(4) over(order by date_data.time_to_delivery) as ntile_del_time from
(select cust.customer_state, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) as ord_purch_ts, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) as ord_del_cust_dt,
timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day) as time_to_delivery from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) is not null) as date_data) as ntile_data
group by ntile_data.ntile_del_time
order by ntile_data.ntile_del_time;

select 
case
    when ntile_data.ntile_del_time = 1 then '1st_Quartile(Q1)'
    when ntile_data.ntile_del_time = 2 then '2nd_Quartile(Q2)'
    when ntile_data.ntile_del_time = 3 then '3rd_Quartile(Q3)'
    when ntile_data.ntile_del_time = 4 then '4th_Quartile(Q4)'
    else ''
end as del_time_quartile,
min(ntile_data.time_to_delivery) as min_del_time, max(ntile_data.time_to_delivery) as max_del_time, max(ntile_data.time_to_delivery)-min(ntile_data.time_to_delivery) as del_time_range from
(select date_data.customer_state, date_data.time_to_delivery,
ntile(4) over(order by date_data.time_to_delivery) as ntile_del_time from
(select cust.customer_state, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) as ord_purch_ts, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) as ord_del_cust_dt,
timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day) as time_to_delivery from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) is not null) as date_data) as ntile_data
group by ntile_data.ntile_del_time
order by ntile_data.ntile_del_time;



-- Avg diff_estimated_delivery is -10.958 ~ -11 days - So orders are delivered 11 days before estimated delivery date
select round(avg(timestamp_diff(order_delivered_customer_date, order_estimated_delivery_date, day)),2) as avg_diff_estimated_delivery from `target-retail-64862.target_retail.orders`
where FORMAT_TIMESTAMP("%Y-%m-%d", order_delivered_customer_date) is not null;

-- Median diff_estimated_delivery date is -11 days - So orders are delivered 11 days before estimated delivery date
select ntile_data.ntile_est_del_time, min(ntile_data.diff_estimated_delivery) as min_del_time, max(ntile_data.diff_estimated_delivery) as max_del_time, max(ntile_data.diff_estimated_delivery)-min(ntile_data.diff_estimated_delivery) as del_time_range from
(select date_data.customer_state, date_data.diff_estimated_delivery,
ntile(4) over(order by date_data.diff_estimated_delivery) as ntile_est_del_time from
(select cust.customer_state,
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_estimated_delivery_date) as ord_est_del_dt, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) as ord_del_cust_dt,
timestamp_diff(order_delivered_customer_date, order_estimated_delivery_date, day) as diff_estimated_delivery from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) is not null) as date_data) as ntile_data
group by ntile_data.ntile_est_del_time
order by ntile_data.ntile_est_del_time;


select 
case
    when ntile_data.ntile_est_del_time = 1 then '1st_Quartile(Q1)'
    when ntile_data.ntile_est_del_time = 2 then '2nd_Quartile(Q2)'
    when ntile_data.ntile_est_del_time = 3 then '3rd_Quartile(Q3)'
    when ntile_data.ntile_est_del_time = 4 then '4th_Quartile(Q4)'
    else ''
end as diff_est_del_time_quartile,
min(ntile_data.diff_estimated_delivery) as min_del_time, max(ntile_data.diff_estimated_delivery) as max_del_time, max(ntile_data.diff_estimated_delivery)-min(ntile_data.diff_estimated_delivery) as del_time_range from
(select date_data.customer_state, date_data.diff_estimated_delivery,
ntile(4) over(order by date_data.diff_estimated_delivery) as ntile_est_del_time from
(select cust.customer_state,
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_estimated_delivery_date) as ord_est_del_dt, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) as ord_del_cust_dt,
timestamp_diff(order_delivered_customer_date, order_estimated_delivery_date, day) as diff_estimated_delivery from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) is not null) as date_data) as ntile_data
group by ntile_data.ntile_est_del_time
order by ntile_data.ntile_est_del_time;

select cust.customer_state, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) as ord_purch_ts, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_estimated_delivery_date) as ord_est_del_dt, 
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) as ord_del_cust_dt,
timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day) as time_to_delivery, 
timestamp_diff(order_delivered_customer_date, order_estimated_delivery_date, day) as diff_estimated_delivery from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
where FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_delivered_customer_date) is not null;

-- So estimated delivery date should be 21 to 23 days from the date of order and the target retail should attempt to deliver these order within 11 days from the date of order.




-- Calculating top 5 states with average time_to_delivery being very high
-- Replacing with median value - 10 for null

select cust.customer_state,
round(avg(coalesce(timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day),10)),2) as avg_time_to_delivery from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
group by cust.customer_state
order by avg(coalesce(timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day),10)) desc
limit 5;

-- Calculating top 5 states with average time_to_delivery being very low
-- Replacing with median value - 10 for null
select cust.customer_state,
round(avg(coalesce(timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day),10)),2) as avg_time_to_delivery from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
group by cust.customer_state
order by avg(coalesce(timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day),10)) asc
limit 5;

-- Calculating top 5 states with average diff_estimated_delivery being very high
-- Replacing with median value - 11 for null

select cust.customer_state,
round(avg(coalesce(timestamp_diff(order_delivered_customer_date, order_estimated_delivery_date, day),-11)),2) as avg_diff_estimated_delivery from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
group by cust.customer_state
order by avg(coalesce(timestamp_diff(order_delivered_customer_date, order_estimated_delivery_date, day),-11)) desc
limit 5;

-- Calculating top 5 states with average diff_estimated_delivery being very low
-- Replacing with median value - 11 for null
select cust.customer_state,
round(avg(coalesce(timestamp_diff(order_delivered_customer_date, order_estimated_delivery_date, day),-11)),2) as avg_diff_estimated_delivery from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
group by cust.customer_state
order by avg(coalesce(timestamp_diff(order_delivered_customer_date, order_estimated_delivery_date, day),-11))
limit 5;






select cust.customer_state,

round(avg(timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day)),2) as avg_time_to_delivery

from target-retail-64862.target_retail.customers cust

left join target-retail-64862.target_retail.orders ord on ord.customer_id = cust.customer_id

where ord.order_purchase_timestamp is not null

group by cust.customer_state

order by round(avg(timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day)),2)

limit 5;


select cust.customer_state,

round(avg(timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day)),2) as avg_time_to_delivery

from target-retail-64862.target_retail.customers cust

left join target-retail-64862.target_retail.orders ord on ord.customer_id = cust.customer_id

where ord.order_purchase_timestamp is not null

group by cust.customer_state

order by round(avg(timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day)),2) desc

limit 5;


select cust.customer_state,

round(avg(timestamp_diff(order_delivered_customer_date,

order_estimated_delivery_date, day)),2) as avg_diff_estimated_delivery from target-retail-64862.target_retail.customers cust

left join target-retail-64862.target_retail.orders ord on ord.customer_id = cust.customer_id

group by cust.customer_state

order by round(avg(timestamp_diff(order_delivered_customer_date,

order_estimated_delivery_date, day)),2) desc

limit 5;


select cust.customer_state,

round(avg(timestamp_diff(order_delivered_customer_date,

order_estimated_delivery_date, day)),2) as avg_diff_estimated_delivery from target-retail-64862.target_retail.customers cust

left join target-retail-64862.target_retail.orders ord on ord.customer_id = cust.customer_id

group by cust.customer_state

order by round(avg(timestamp_diff(order_delivered_customer_date,

order_estimated_delivery_date, day)),2)

limit 5;