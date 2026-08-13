create table hmwrk 
(
user_id UInt64,
action String,
expense UInt64
)
engine = MergeTree()
order by user_id;

drop dictionary email_dict ;

CREATE DICTIONARY user_email_dict
(
    user_id UInt64,
    email   String
)
PRIMARY KEY user_id
SOURCE(FILE(path '/var/lib/clickhouse/user_files/files.csv' format 'CSVWithNames'))
LAYOUT(HASHED())
LIFETIME(MIN 0 MAX 300);

insert into `default`.hmwrk (user_id, action, expense) values 
(4, 'buy',  100),
(4, 'buy',  200),
(4, 'sell',  50),
(5, 'buy',  300),
(5, 'sell', 150),
(5, 'sell',  80),
(6, 'buy',  400),
(6, 'buy',  120),
(6, 'sell', 200);

select * from user_email_dict ed ;

select dictGet('user_email_dict','email',user_id),
action, expense,
sum(expense) over (
	partition by action
	order by dictGet('user_email_dict','email',user_id), expense
	) as cummulative_expense
from hmwrk;

alice@example.com	buy	100	100
alice@example.com	buy	200	300
ben@example.com		buy	300	600
bob@example.com		buy	300	900
carol@example.com	buy	120	1020
carol@example.com	buy	400	1420
jack@eample.com		buy	100	1520
jack@eample.com		buy	200	1720
margo@example.com	buy	120	1840
margo@example.com	buy	400	2240
alice@example.com	sell 50	50
ben@example.com		sell 80	130
ben@example.com		sell 150	280
bob@example.com		sell 80	360
bob@example.com		sell 150	510
carol@example.com	sell 200	710
jack@eample.com		sell 50	760
margo@example.com	sell 200	960