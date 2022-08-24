--In-depth Exploration:

--Is there a growing trend on e-commerce in Brazil? How can we describe a complete scenario? Can we see some seasonality with peaks at specific months?

select purc_ord.order_date, count(*) as count_of_orders from
(select customer_id, FORMAT_TIMESTAMP("%Y-%m-%d", order_purchase_timestamp) as order_date from `target-retail-64862.target_retail.orders`) as purc_ord
group by purc_ord.order_date
order by purc_ord.order_date;

--What time do Brazilian customers tend to buy (Dawn, Morning, Afternoon or Night)?

select purc_ord.hour_of_the_day, count(*) as count_of_orders from
(select customer_id, EXTRACT(hour from order_purchase_timestamp) as hour_of_the_day,  from `target-retail-64862.target_retail.orders`) as purc_ord
group by purc_ord.hour_of_the_day
order by purc_ord.hour_of_the_day;

select ord_week.Is_Weekend, ord_week.hour_of_the_day, count(*) as count_of_orders from
(select customer_id, order_purchase_timestamp, EXTRACT(hour from order_purchase_timestamp) as hour_of_the_day, EXTRACT(DAYOFWEEK FROM order_purchase_timestamp) as day_of_week,
case
    when EXTRACT(DAYOFWEEK FROM order_purchase_timestamp) IN (2,3,4,5,6) THEN 'Weekday'
    when EXTRACT(DAYOFWEEK FROM order_purchase_timestamp) IN (7,1) THEN 'Weekend'
    else ''
end as Is_Weekend 
from `target-retail-64862.target_retail.orders`
order by order_purchase_timestamp) as ord_week
group by ord_week.Is_Weekend, ord_week.hour_of_the_day
order by ord_week.Is_Weekend, ord_week.hour_of_the_day;
