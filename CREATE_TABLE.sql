create database restaurant_db;
use restaraunt_db;
create table restaurant_menu
(
	id	UInt32 		comment 'Уникальный идентификатор',
	name String	comment 'Название блюда',
	description	Nullable(String) comment 'Описание блюда(может быть пустым)',
	category LowCardinality(String) comment 'Категория блюда(основное, закуска, десерт и т.п.',
	price Decimal64(2)	comment 'Цена'	,
	currency    LowCardinality(String)          COMMENT 'Валюта (RUB, USD и т.д.)',
    is_available UInt8                          COMMENT '1 - доступно, 0 - недоступно',
    created_at  DateTime                        COMMENT 'Дата и время создания записи',
    updated_at  Nullable(DateTime)              COMMENT 'Дата и время последнего обновления')
    engine = MergeTree
    order by (id, category)
    comment 'таблица с меню ресторана'