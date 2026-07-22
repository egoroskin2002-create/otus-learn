SELECT * FROM dish_copy LIMIT 5;

DETACH TABLE dish_copy PERMANENTLY;
SELECT * FROM dish_copy;

ATTACH TABLE dish_copy;

SELECT * FROM dish_copy LIMIT 5;
CREATE DATABASE restaurant_archive;
CREATE TABLE restaurant_archive.dish_copy
ENGINE = MergeTree ORDER BY (name)
AS SELECT * FROM dish_copy;
SELECT * FROM restaurant_archive.dish_copy LIMIT 5;
DETACH DATABASE restaurant_archive;
SELECT * FROM restaurant_archive.dish_copy;
ATTACH DATABASE restaurant_archive;
SELECT * FROM restaurant_archive.dish_copy LIMIT 5;
DROP TABLE dish_copy;
DROP DATABASE restaurant_archive;
SHOW DATABASES;