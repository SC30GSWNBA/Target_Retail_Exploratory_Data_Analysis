select * from `target-retail-64862.target_retail.order_reviews`;

-- 99224 records in order_reviews table
select count(*) from `target-retail-64862.target_retail.order_reviews`;

-- 98673 distinct order_ids in order_reviews table
select count(distinct order_id) from `target-retail-64862.target_retail.order_reviews`;

select order_id, count(*) from `target-retail-64862.target_retail.order_reviews`
group by order_id
having count(*) >= 2;

select * from `target-retail-64862.target_retail.order_reviews`
where order_id in ('29062384ce4975f78aeba6a496510386','a17af8e6044c5ccaa87b1d97559dc554','5123fb3580d7dd11bfd9c25321e43ed5','3df55fc07ff463109ce0422439693aee');

-- 98410 distinct review_ids in order_reviews table
select count(distinct review_id) from `target-retail-64862.target_retail.order_reviews`;

-- Count of different review scores
select review_score, count(*) as review_score_count from `target-retail-64862.target_retail.order_reviews`
group by review_score
order by review_score;

-- Distribution of resolution time
select hour_dist.bracket as percentile, min(hour_dist.hours) as min_hours, max(hour_dist.hours) as max_hours, max(hour_dist.hours)-min(hour_dist.hours) as hours_range from
(select *, timestamp_diff(review_answer_timestamp, review_creation_date, hour) as hours, ntile(4) over (order by timestamp_diff(review_answer_timestamp, review_creation_date, hour)) as bracket from `target-retail-64862.target_retail.order_reviews`) as hour_dist
group by hour_dist.bracket
order by hour_dist.bracket;


select 
case
    when hour_dist.bracket = 1 then '25th Percentile'
    when hour_dist.bracket = 2 then '50th Percentile'
    when hour_dist.bracket = 3 then '75th Percentile'
    when hour_dist.bracket = 4 then '100th Percentile'
    else ''
end as percentile_bracket,
min(hour_dist.hours) as min_hours, max(hour_dist.hours) as max_hours, max(hour_dist.hours)-min(hour_dist.hours) as hours_range
from
(select *, timestamp_diff(review_answer_timestamp, review_creation_date, hour) as hours, ntile(4) over (order by timestamp_diff(review_answer_timestamp, review_creation_date, hour)) as bracket from `target-retail-64862.target_retail.order_reviews`) as hour_dist
group by hour_dist.bracket
order by hour_dist.bracket;

-- IQR = 74 - 24 = 50
-- Anything above 1.5 IRQ is outlier
-- So anything above 74 + 1.5 * 50 = 74 + 75 ~ 149 is a potential outlier

-- 6305 records are outliers
select count(*) from `target-retail-64862.target_retail.order_reviews`
where timestamp_diff(review_answer_timestamp, review_creation_date, hour) > 149;


select review_score, count(*) from `target-retail-64862.target_retail.order_reviews`
where timestamp_diff(review_answer_timestamp, review_creation_date, hour) > 149
group by review_score;

