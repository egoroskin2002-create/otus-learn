CREATE TABLE transactions (
    transaction_id UInt32,
    user_id UInt32,
    product_id UInt32,
    quantity UInt8,
    price Float32,
    transaction_date Date
) ENGINE = MergeTree()
ORDER BY (transaction_id);

INSERT INTO transactions VALUES
(1, 101, 1, 2, 49.99, '2024-01-15'),
(2, 102, 2, 1, 149.99, '2024-01-16'),
(3, 101, 3, 3, 29.99, '2024-02-01'),
(4, 103, 1, 1, 49.99, '2024-02-10'),
(5, 104, 4, 2, 199.99, '2024-03-05'),
(6, 102, 2, 1, 89.99, '2024-03-20');

////БЛОК 1
select * from transactions t ;

select sum(quantity*price) as total_profit from transactions t ;

select avg(price*quantity) as avg_profit from transactions t ;

select sum(quantity) as total_sold from transactions t ;

select uniq(user_id) as uniq_users from transactions t; 

////БЛОК 2
select transaction_id,
 formatDateTime(transaction_date, '%Y-%m-%d') as date_string from transactions;

select transaction_id, 
    toYear(transaction_date) as tr_year, 
    toMonth(transaction_date) as tr_month, 
    toYYYYMM(transaction_date) as tr_yyyymm from transactions t ;

select transaction_id, price,
round(price) as round_price from transactions t ;

select transaction_id, 
toString(transaction_id) as tr_id_str from transactions t ;

/////БЛОК 3

create function calc_total_price as (x, y) -> (x * y);
create function calc_total_price_r as (x, y) -> round(x * y);

select transaction_id, quantity, price,
calc_total_price(price, quantity) as total_price from transactions t ;

select transaction_id, quantity, price,
calc_total_price_r(price, quantity) as total_price from transactions t ;

create function classify_transaction as (x,y) -> if(x*y > 100, 'hight', 'low') ;

select transaction_id, price, quantity,
calc_total_price(quantity, price) as total_price,
classify_transaction(price,quantity) as class_trans from transactions t ;




