select * from `target-retail-64862.target_retail.payments`
limit 100;

-- 103886 records in payments table
select count(*) from `target-retail-64862.target_retail.payments`;

-- 99440 distinct order_id in payments table
select count(distinct order_id) from `target-retail-64862.target_retail.payments`;

-- 29 distinct sequences of payments
select distinct payment_sequential from `target-retail-64862.target_retail.payments`;

-- 5 different payment methods in payments table
select distinct payment_type from `target-retail-64862.target_retail.payments`;


-- 24 distinct installments
select distinct payment_installments from `target-retail-64862.target_retail.payments`;

-- histogram on number of installments taken by customers
select installment.installment_no, count(*) as installment_counts from
(select order_id, max(payment_installments) as installment_no from `target-retail-64862.target_retail.payments`
group by order_id
order by order_id) as installment
group by installment.installment_no
order by installment.installment_no;


select installment.installment_no, installment.payment_type, count(*) as installment_counts from
(select order_id, payment_type, payment_installments as installment_no from `target-retail-64862.target_retail.payments`
group by order_id, payment_type, payment_installments) as installment
group by installment.installment_no, installment.payment_type
order by installment.installment_no, installment.payment_type;

-- histogram on number of payments made by each customers
select sequence.sequence_no, count(*) as sequence_counts from
(select order_id, max(payment_sequential) as sequence_no from `target-retail-64862.target_retail.payments`
group by order_id
order by order_id) as sequence
group by sequence.sequence_no
order by sequence.sequence_no;


-- distribution of payment value - Too many outliers

select final.bracket, min(final.amount) as min_amount, max(final.amount) as max_amount, max(final.amount)-min(final.amount) as range_amount, count(*) as distribution from
(select amnt.*, ntile(4) over (order by amnt.amount) as bracket from
(select order_id, sum(payment_value) as amount from `target-retail-64862.target_retail.payments`
group by order_id) amnt) final
group by final.bracket
order by final.bracket;


-- Count of Payment Types
select pt.payment_type, count(*) as payment_type_count from
(select order_id, max(payment_type) as payment_type from `target-retail-64862.target_retail.payments`
group by order_id) pt
group by pt.payment_type;
