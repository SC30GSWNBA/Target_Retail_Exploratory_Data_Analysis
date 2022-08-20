select * from `target-retail-64862.target_retail.products`;

-- 32951 records in products table
select count(*) from `target-retail-64862.target_retail.products`;

-- 32951 distinct product_id in products table
select count(distinct product_id) from `target-retail-64862.target_retail.products`;


-- 74 distinct categories of product
select product_category, count(*) as product_category_count
from `target-retail-64862.target_retail.products`
group by product_category
order by count(*) desc;

-- Count of product by photos taken
select product_photos_qty, count(*) as photo_count
from `target-retail-64862.target_retail.products`
group by product_photos_qty
order by count(*) desc;


-- Distribution of weight -- Too Many outliers
select 
case
    when weight_dist.bracket = 1 then '25th Percentile'
    when weight_dist.bracket = 2 then '50th Percentile'
    when weight_dist.bracket = 3 then '75th Percentile'
    when weight_dist.bracket = 4 then '100th Percentile'
    else ''
end as weight_distribution,
min(weight_dist.product_weight_g) as min_weight, max(weight_dist.product_weight_g) as max_weight, max(weight_dist.product_weight_g)-min(weight_dist.product_weight_g) as weight_range from
(select *, ntile(4) over (order by product_weight_g) as bracket from `target-retail-64862.target_retail.products`) as weight_dist
group by weight_dist.bracket
order by weight_dist.bracket;

select count(*) from `target-retail-64862.target_retail.products`
where product_weight_g > 3300;

-- Distribution of volume -- Too many outliers
select 
case
    when vol_dist.bracket = 1 then '25th Percentile'
    when vol_dist.bracket = 2 then '50th Percentile'
    when vol_dist.bracket = 3 then '75th Percentile'
    when vol_dist.bracket = 4 then '100th Percentile'
    else ''
end as volume_distribution, min(vol_dist.product_volume) as min_vol, max(vol_dist.product_volume) as max_vol, max(vol_dist.product_volume)-min(vol_dist.product_volume) as vol_range from
(select *, product_height_cm*product_length_cm*product_width_cm as product_volume, ntile(4) over (order by product_height_cm*product_length_cm*product_width_cm) as bracket from `target-retail-64862.target_retail.products`) as vol_dist
group by vol_dist.bracket
order by vol_dist.bracket;


-- From the above table we that Inter Quartile Range for weight distribution of products = 18480 - 2880 = 15600 grams or 1.6 kilograms

-- So anything above 18480 + 1.5 * 15600 = 18480 + 23400 ~ 41880 cubic cm is a potential outlier

-- We see that 3262 records/products are outliers or have product weight more than 41880 cubic cm

select count(*) from `target-retail-64862.target_retail.products`
where product_height_cm*product_length_cm*product_width_cm > 41880;

