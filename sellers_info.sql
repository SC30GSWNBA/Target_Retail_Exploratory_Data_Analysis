select * from `target-retail-64862.target_retail.sellers`;

-- 3095 records in sellers table
select count(*) from `target-retail-64862.target_retail.sellers`;

select count(distinct seller_id) from `target-retail-64862.target_retail.sellers`;

-- 611 distinct cities in sellers table
select count(distinct(seller_city)) from `target-retail-64862.target_retail.sellers`;

-- 23 distinct states in sellers table
select count(distinct(seller_state)) from `target-retail-64862.target_retail.sellers`;

-- SP state has the highest and AC/AM/MA/PA/PI has the least number of sellers 
select seller_state, count(*) as state_count from `target-retail-64862.target_retail.sellers`
group by seller_state
order by count(*) desc;

-- sao paulo city has the highest number of sellers
select seller_city, count(*) as city_count from `target-retail-64862.target_retail.sellers`
group by seller_city
order by count(*) desc;

-- SP state has the highest and AC/AM/MA/PA/PI has the least number of cities in sellers table
select seller_state, count(distinct seller_city) as city_count from `target-retail-64862.target_retail.sellers`
group by seller_state
order by count(distinct seller_city) desc;
