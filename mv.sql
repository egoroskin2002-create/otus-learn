create table default.sales (
id UInt32,
product_id UInt32,
quantity UInt32,
price Float32,
sale_date DateTime
)
engine = MergeTree
order by product_id;

INSERT INTO sales VALUES
(1,  101, 5,  10.5,  '2024-01-01 10:00:00'),
(2,  102, 3,  25.0,  '2024-01-01 11:00:00'),
(3,  101, 2,  10.5,  '2024-01-02 09:00:00'),
(4,  103, 8,  5.75,  '2024-01-02 14:00:00'),
(5,  102, 1,  25.0,  '2024-01-03 16:00:00'),
(6,  101, 4,  10.5,  '2024-01-03 18:00:00'),
(7,  103, 6,  5.75,  '2024-01-04 12:00:00'),
(8,  104, 10, 3.0,   '2024-01-04 15:00:00'),
(9,  104, 7,  3.0,   '2024-01-05 10:00:00'),
(10, 102, 2,  25.0,  '2024-01-05 17:00:00');

select * from sales;

alter table sales 
	add projection sales_project1
	(
		select product_id,
		sum(quantity),
		sum(price*quantity)
		group by product_id
		)
	
alter table sales 
	materialize projection sales_project;

SELECT mutation_id, command, is_done
FROM system.mutations
WHERE table = 'sales'
ORDER BY create_time DESC
LIMIT 5;

select product_id,
	sum(quantity) as total_qua, 
	sum(quantity*price) as total_sales
from sales
group by product_id 
order by product_id;

EXPLAIN
SELECT
    product_id,
    sum(quantity)         AS total_quantity,
    sum(quantity * price) AS total_sales
FROM sales
GROUP BY product_id
ORDER BY product_id;
drop table if exists sales_mv_target;

create table sales_mv_target (
product_id UInt32,
total_quantity AggregateFunction(sum, UInt32),
total_sales AggregateFunction(sum, Float64)
) engine = AggregatingMergeTree
order by product_id;

create materialized view sales_mv
to sales_mv_target
as select
	product_id,
	sumState(quantity) as total_quantity,
	sumState(quantity*price) as total_sales
from sales
group by product_id;


INSERT INTO sales_mv_target
SELECT
    product_id,
    sumState(quantity)                        AS total_quantity,
    sumState(toFloat64(quantity * price))     AS total_sales
FROM sales
GROUP BY product_id;

select product_id,
sum(quantity),
sum(quantity*price)
from sales
group by product_id
order by product_id
settings optimize_use_projections= 0;
//0,47s

SELECT
    product_id,
    sum(quantity)         AS total_quantity,
    sum(quantity * price) AS total_sales
FROM sales
GROUP BY product_id
ORDER BY product_id;
///0,41
SELECT
    product_id,
    sumMerge(total_quantity) AS total_quantity,
    sumMerge(total_sales)    AS total_sales
FROM sales_mv
GROUP BY product_id
ORDER BY product_id;
//0.053

