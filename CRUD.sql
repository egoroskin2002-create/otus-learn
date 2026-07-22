insert into restaurant_menu (id, name, description, category, price, currency, is_available, created_at, updated_at)
values
(1, 'Борщ', 'Традиционно приготовленный', 'Супы', 350.00, 'RUB', 1, now(), null),
(2,'Цезарь',      'Салат с курицей и пармезаном', 'Салаты',  420.00, 'RUB', 1, now(), NULL),
(3, 'Стейк рибай', NULL,                           'Горячее', 1500.00,'RUB', 1, now(), NULL),
(4, 'Тирамису',    'По итальянскому рецепту',           'Десерты', 280.00, 'RUB', 1, now(), NULL),
(5, 'Лимонад',     'Домашний лимонад',             'Напитки', 150.00, 'RUB', 1, now(), NULL);

select * from restaurant_menu rm ;


alter table restaurant_menu update price = 400.00 where id = 1;

select id, price from restaurant_menu rm where price = 400.00

alter table restaurant_menu delete where id in (3,5);
select * from restaurant_menu rm ;Ф
insert into restaurant_menu (id, name, description, category, price, currency, is_available, created_at, updated_at)
values 
(6, 'Пицца Маргарита', 'Классическая итальянская пицца', 'Горячее', 650.00, 'RUB', 1, now(), NULL),
(7, 'Греческий салат', NULL,                             'Салаты',  380.00, 'RUB', 1, now(), NULL),
(8, 'Капучино',        null ,        'Напитки', 200.00, 'RUB', 1, now(), NULL);
select * from restaurant_menu rm where price between 0 and 500.00;
alter table restaurant_menu delete where price between 0 and 300;
select * from restaurant_menu rm where price between 0 and 500.00;
alter table restaurant_menu add column callories Nullable(UInt32) comment 'Кол-во калорий на порцию';
select * from restaurant_menu;
alter table restaurant_menu add column is_vegan UInt8 default 0 comment 'является ли блюдо веганским, если да, то 1';
select * from restaurant_menu;
alter table restaurant_menu  drop column currency, drop column updated_at;
select * from restaurant_menu rm ;

describe table restaurant_menu;

