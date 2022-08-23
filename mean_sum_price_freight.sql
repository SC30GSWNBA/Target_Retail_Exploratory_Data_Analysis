-- Mean & Sum of price and freight value by customer state

select cust.customer_id, cust.customer_state, ord.order_id, oi.price, oi.freight_value from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
left join `target-retail-64862.target_retail.order_items` oi on oi.order_id = ord.order_id;

-- Let's find the distribution of freight prices - considering null - 17.09
select bracket.ntile_freight, min(bracket.freight_value) as min_freight, max(bracket.freight_value) as max_freight, max(bracket.freight_value)-min(bracket.freight_value) as freight_range from
(select freight_items.order_id, freight_items.freight_value, ntile(4) over (order by freight_items.freight_value) as ntile_freight from
(select ord.order_id, sum(ord_it.freight_value) as freight_value from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
group by ord.order_id) as freight_items) as bracket
group by bracket.ntile_freight
order by bracket.ntile_freight;


-- Let's find the distribution of freight prices - considering not null - 17.17
select bracket.ntile_freight, min(bracket.freight_value) as min_freight, max(bracket.freight_value) as max_freight, max(bracket.freight_value)-min(bracket.freight_value) as freight_range from
(select freight_items.order_id, freight_items.freight_value, ntile(4) over (order by freight_items.freight_value) as ntile_freight from
(select ord.order_id, sum(ord_it.freight_value) as freight_value from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where ord_it.freight_value is not null
group by ord.order_id) as freight_items) as bracket
group by bracket.ntile_freight
order by bracket.ntile_freight;


select
case when bracket.ntile_freight_value = 1 then '1st_Quartile (Q1)'
when bracket.ntile_freight_value = 2 then '2nd_Quartile(Q2)'
when bracket.ntile_freight_value = 3 then '3rd_Quartile(Q3)'
when bracket.ntile_freight_value = 4 then '4th_Quartile(Q4)'
else ''
end as freight_value_quartile,
round(min(bracket.freight_value),2) as min_freight_value,
round(max(bracket.freight_value),2) as max_freight_value,
round(max(bracket.freight_value)-min(bracket.freight_value),2) as freight_value_range from
(select freight_value_items.order_id, freight_value_items.freight_value, ntile(4) over (order by freight_value_items.freight_value) as ntile_freight_value from
(select ord.order_id, sum(ord_it.freight_value) as freight_value from target-retail-64862.target_retail.orders ord
left join target-retail-64862.target_retail.order_items ord_it
on ord_it.order_id = ord.order_id
where ord_it.freight_value is not null
group by ord.order_id) as freight_value_items) as bracket
group by bracket.ntile_freight_value
order by bracket.ntile_freight_value;



--Finding mean freight value : 22.82

select avg(freight_value_items.freight_value) as mean_freight_value_items from

(select ord.order_id, sum(ord_it.freight_value) as freight_value from `target-retail-64862.target_retail.orders` ord

left join `target-retail-64862.target_retail.order_items` ord_it

on ord_it.order_id = ord.order_id

group by ord.order_id) as freight_value_items;

-- Distribution IRQ = 24.04 - 13.85 = 10.19 So anything beyond = Q3 + 1.5 * IQR is an outlier = 24.04 + 1.5 * 10.19 = 39.325
select bracket.ntile_freight, min(bracket.freight_value) as min_freight, max(bracket.freight_value) as max_freight, max(bracket.freight_value)-min(bracket.freight_value) as freight_range from
(select freight_items.order_id, freight_items.freight_value, ntile(4) over (order by freight_items.freight_value) as ntile_freight from
(select ord.order_id, sum(ord_it.freight_value) as freight_value from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.order_items` ord_it
on ord_it.order_id = ord.order_id
where ord_it.freight_value is not null
group by ord.order_id) as freight_items) as bracket
group by bracket.ntile_freight
order by bracket.ntile_freight;

-- Finding Outliers > 39.325 : 9941 orders have freight value more than 39.325

select count(*) from

(select ord.order_id, sum(ord_it.freight_value) as freight_value from `target-retail-64862.target_retail.orders` ord

left join `target-retail-64862.target_retail.order_items` ord_it

on ord_it.order_id = ord.order_id

where ord_it.freight_value is not null

group by ord.order_id

having sum(ord_it.freight_value) > 39.325);

-- Replacing all null freight values with median freight value i.e 17.09 and all price values with 85
select cust.customer_id, cust.customer_state, ord.order_id, coalesce(oi.price,85) as price, coalesce(oi.freight_value,17.09) as freight_value from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
left join `target-retail-64862.target_retail.order_items` oi on oi.order_id = ord.order_id;


--Replacing all null freight values with median freight value i.e 17.09 and all price values with 85 - considering nulls
select cust.customer_state, avg(coalesce(oi.price,85)) as mean_price, sum(coalesce(oi.price,85)) as sum_price, avg(coalesce(oi.freight_value,17.09)) as mean_freight, sum(coalesce(oi.freight_value,17.09)) as sum_freight from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
left join `target-retail-64862.target_retail.order_items` oi on oi.order_id = ord.order_id
group by cust.customer_state;


--Replacing all null freight values with median freight value i.e 22.82 and all price values with 87 - without considering nulls
select cust.customer_state, round(avg(coalesce(oi.price,87)),2) as mean_price, round(sum(coalesce(oi.price,87)),2) as sum_price, round(avg(coalesce(oi.freight_value,17.17)),2) as mean_freight, round(sum(coalesce(oi.freight_value,17.17)),2) as sum_freight from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord on ord.customer_id = cust.customer_id
left join `target-retail-64862.target_retail.order_items` oi on oi.order_id = ord.order_id
group by cust.customer_state;

