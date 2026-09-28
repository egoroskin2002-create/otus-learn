CREATE DATABASE IF NOT EXISTS homework;


CREATE TABLE homework.local_table (
    id UInt64,
    name String,
    created_at DateTime DEFAULT now()
) ENGINE = MergeTree()
ORDER BY id;


CREATE TABLE homework.s3_table (
    id UInt64,
    value String,
    created_at DateTime DEFAULT now()
) ENGINE = MergeTree()
ORDER BY id
SETTINGS storage_policy = 's3_main';

INSERT INTO homework.local_table (id, name) SELECT number, concat('user_', toString(number)) FROM numbers(1000);
INSERT INTO homework.s3_table (id, value) SELECT number, concat('data_', toString(number)) FROM numbers(1000);

SELECT
    'local_table',
    count()
FROM homework.local_table
UNION ALL
SELECT
    's3_table',
    count()
FROM homework.s3_table

Query id: cda7d003-9666-4eb0-907f-e59444f0ff6d

   ┌─'local_table'─┬─count()─┐
1. │ local_table   │    1000 │
2. │ s3_table      │    1000 │
   └───────────────┴─────────┘

DROP TABLE homework.local_table;

ALTER TABLE homework.s3_table UPDATE value = 'hacked' WHERE id < 100;

SELECT count()
FROM homework.s3_table
WHERE value = 'hacked'

Query id: a890818b-bcf4-4f87-9403-5186b0ea2da7

   ┌─count()─┐
1. │     100 │
   └─────────┘
   
SELECT
    'local_table' AS t,
    count()
FROM homework.local_table

Query id: 8087bcea-0ab5-4030-8dca-0ecc55b2e84e

   ┌─t───────────┬─count()─┐
1. │ local_table │    1000 │
   └─────────────┴─────────┘
   
SELECT
    'hacked_rows',
    count()
FROM homework.s3_table
WHERE value = 'hacked'

Query id: 025e8f56-65ce-4fd1-b681-3fdd7fc6b276

   ┌─'hacked_rows'─┬─count()─┐
1. │ hacked_rows   │       0 │
   └───────────────┴─────────┘
   