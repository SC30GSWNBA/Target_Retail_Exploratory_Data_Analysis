-- Region wise monthly orders
select reg.region, reg.date_extract, count(*) as count_of_orders from
(select cust.customer_state,
CASE
    WHEN cust.customer_state IN ('SP','RJ','MG','ES','RJ') THEN 'SouthEast'
    WHEN cust.customer_state IN ('RS','PR','SC') THEN 'South'
    WHEN cust.customer_state IN ('BA','PE','CE','MA','PB','PI','RN','AL','SE') THEN 'NorthEast'
    WHEN cust.customer_state IN ('DF','GO','MT','MS') THEN 'CenterWest'
    WHEN cust.customer_state IN ('PA','TO','RO','AM','AC','AP','RR') THEN 'North'
    ELSE 'NA'
END AS Region,
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) as date_extract from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord
on ord.customer_id = cust.customer_id
order by FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp)) as reg
group by reg.region, reg.date_extract
order by reg.region, reg.date_extract;


select reg.region, count(*) as count_of_orders, round(count(*)/99441 * 100, 2) as percent_total_orders from
(select cust.customer_state,
CASE
    WHEN cust.customer_state IN ('SP','RJ','MG','ES','RJ') THEN 'SouthEast'
    WHEN cust.customer_state IN ('RS','PR','SC') THEN 'South'
    WHEN cust.customer_state IN ('BA','PE','CE','MA','PB','PI','RN','AL','SE') THEN 'NorthEast'
    WHEN cust.customer_state IN ('DF','GO','MT','MS') THEN 'CenterWest'
    WHEN cust.customer_state IN ('PA','TO','RO','AM','AC','AP','RR') THEN 'North'
    ELSE 'NA'
END AS Region,
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) as date_extract from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord
on ord.customer_id = cust.customer_id
order by FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp)) as reg
group by reg.region
order by count(*) desc;

select reg.region, reg.year_extract, reg.month_extract, count(*) as count_of_orders from
(select cust.customer_state,
CASE
    WHEN cust.customer_state IN ('SP','RJ','MG','ES') THEN 'SouthEast'
    WHEN cust.customer_state IN ('RS','PR','SC') THEN 'South'
    WHEN cust.customer_state IN ('BA','PE','CE','MA','PB','PI','RN','AL','SE') THEN 'NorthEast'
    WHEN cust.customer_state IN ('DF','GO','MT','MS') THEN 'CenterWest'
    WHEN cust.customer_state IN ('PA','TO','RO','AM','AC','AP','RR') THEN 'North'
    ELSE 'NA'
END AS Region,
EXTRACT(year from ord.order_purchase_timestamp) as year_extract, EXTRACT(month from ord.order_purchase_timestamp) as month_extract from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord
on ord.customer_id = cust.customer_id) as reg
group by reg.region, reg.year_extract, reg.month_extract
order by reg.region, reg.year_extract, reg.month_extract;
 


-- Monthly Orders for top 5 states
select cust_ord.customer_state, cust_ord.date_extract, count(*) as count_of_orders from
(select cust.customer_state,
FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) as date_extract from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord
on ord.customer_id = cust.customer_id
where cust.customer_state IN ('SP','RJ','MG','RS','PR')) as cust_ord
group by cust_ord.customer_state, cust_ord.date_extract
order by cust_ord.customer_state, cust_ord.date_extract;

select cust_ord.customer_state, cust_ord.year_extract, cust_ord.month_extract, count(*) as count_of_orders from
(select cust.customer_state,
EXTRACT(year from ord.order_purchase_timestamp) as year_extract, EXTRACT(month from ord.order_purchase_timestamp) as month_extract from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord
on ord.customer_id = cust.customer_id
where cust.customer_state IN ('SP','RJ','MG','RS','PR')) as cust_ord
group by cust_ord.customer_state, cust_ord.year_extract, cust_ord.month_extract
order by cust_ord.customer_state, cust_ord.year_extract, cust_ord.month_extract;


select count(*) from `target-retail-64862.target_retail.customers` cust
left join `target-retail-64862.target_retail.orders` ord
on ord.customer_id = cust.customer_id
where cust.customer_state IN ('SP','RJ','MG','RS','PR');