--Payment type analysis:

--Month over Month count of orders for different payment types

--Distribution of payment installments and count of orders

select * from `target-retail-64862.target_retail.orders`;

select order_id, payment_type, payment_installments from `target-retail-64862.target_retail.payments`
where order_id in ('00bd50cdd31bd22e9081e6e2d5b3577b','00b4a910f64f24dbcac04fe54088a443','00c405bd71187154a7846862f585a9d4','009ac365164f8e06f59d18a08045f6c4')
order by order_id;

-- There is one missing record in the payments table for customer_id - 86dc2ffce2dfff336de2f386a786e574 with order_id - bfbd0f9bdef84302105ad712db648a6c
select ord.order_id, ord.customer_id, pay.order_id from `target-retail-64862.target_retail.orders` ord
left join `target-retail-64862.target_retail.payments` pay on pay.order_id = ord.order_id
where pay.order_id is NULL;

-- There are certain orders (00bd50cdd31bd22e9081e6e2d5b3577b, 00b4a910f64f24dbcac04fe54088a443, 00c405bd71187154a7846862f585a9d4, 009ac365164f8e06f59d18a08045f6c4) which are paid through different payment modes and hence the sum of count of orders across different payment types will never be 99440
select ord_pay.payment_type, ord_pay.year, ord_pay.month, count(distinct(ord_pay.order_id)) as count_of_orders from
(select pay.payment_type, EXTRACT(YEAR from ord.order_purchase_timestamp) as year, EXTRACT(MONTH from ord.order_purchase_timestamp) as month, ord.order_id  from `target-retail-64862.target_retail.orders` ord
inner join `target-retail-64862.target_retail.payments` pay on pay.order_id = ord.order_id) as ord_pay
group by ord_pay.payment_type, ord_pay.year, ord_pay.month
order by ord_pay.payment_type, ord_pay.year, ord_pay.month;


select pay.payment_type, FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp) as order_purchase_timestamp, ord.order_id  from `target-retail-64862.target_retail.orders` ord
inner join `target-retail-64862.target_retail.payments` pay on pay.order_id = ord.order_id
group by pay.payment_type, FORMAT_TIMESTAMP("%Y-%m-%d", ord.order_purchase_timestamp), ord.order_id;
