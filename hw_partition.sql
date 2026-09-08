create table user_activity 
(
	user_id UInt32,
	activity_type String,
	activity_date DateTime

) engine = MergeTree
partition by toYYYYMM(activity_date)
order by (user_id, activity_date);

INSERT INTO user_activity (user_id, activity_type, activity_date) VALUES
    (1, 'login', '2024-01-10 10:00:00'),
    (1, 'purchase', '2024-01-10 10:30:00'),
    (2, 'login', '2024-01-15 12:00:00'),
    (2, 'logout', '2024-02-01 14:00:00'),
    (3, 'login', '2024-02-10 09:00:00');

select * from user_activity  ;

///Вывод 
1	login	2024-01-10 13:00:00
1	purchase	2024-01-10 13:30:00
2	login	2024-01-15 15:00:00
2	logout	2024-02-01 17:00:00
3	login	2024-02-10 12:00:00

alter table user_activity 
update activity_type = 'buy'
where activity_type = 'purchase';

select * from user_activity ;
///Вывод
1	login	2024-01-10 13:00:00
1	buy	2024-01-10 13:30:00
2	login	2024-01-15 15:00:00
2	logout	2024-02-01 17:00:00
3	login	2024-02-10 12:00:00

///Проверка мутаций
mutation_6.txt	UPDATE activity_type = 'buy' WHERE activity_type = 'purchase'	2026-09-08 20:31:36	1

select * from system.parts where table = 'user_activity';
///Вывод партиций
202401	202401_4_4_0	0
202401	202401_4_4_0_6	1
202402	202402_5_5_0	0
202402	202402_5_5_0_6	1

///удаляем партицию за 01 месяц
alter table user_activity drop partition '202401';
select partition, name, active from system.parts where table = 'user_activity' and active = 1;
/// Вывод
202402	202402_5_5_0_6	1

select * from user_activity ;
///Вывод
2	logout	2024-02-01 17:00:00
3	login	2024-02-10 12:00:00

truncate table user_activity;
select * from user_activity;


