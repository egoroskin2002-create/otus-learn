///БЛОК создания

create database imdb;
use imdb;
create table imdb.actors
( id UInt32,
  first_name String,
  last_name String,
  gender FixedString(1)
  )
  engine = MergeTree order by(id,first_name,last_name,gender);

create table imdb.genres 
(
	movie_id UInt32,
	genre String
)
engine = MergeTree order by (movie_id, genre);

create table imdb.movies
(
	id UInt32,
	name String,
	year UInt32,
	rank Float32 DEFAULT 0
) ENGINE = MergeTree ORDER BY (id, name, year);

CREATE TABLE imdb.roles
(
    actor_id   UInt32,
    movie_id   UInt32,
    role       String,
    created_at DateTime DEFAULT now()
) ENGINE = MergeTree ORDER BY (actor_id, movie_id);

///БЛОК вставки

insert into imdb.actors 
select * from
s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/imdb/imdb_ijs_actors.tsv.gz',
'TSVWithNames');


INSERT INTO imdb.genres
SELECT *
FROM s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/imdb/imdb_ijs_movies_genres.tsv.gz',
'TSVWithNames');

INSERT INTO imdb.movies
SELECT *
FROM s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/imdb/imdb_ijs_movies.tsv.gz',
'TSVWithNames');


insert into imdb.roles(actor_id, movie_id, role, created_at)
select actor_id, movie_id, role, created_at
from s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/imdb/imdb_ijs_roles.tsv.gz',
'TSVWithNames');

///Жанры каждого фильма


select id, name from imdb.movies m  limit 150;
select movie_id, genre from imdb.genres ;

select 
id,
m.name as name,
g.genre as genre 
from imdb.movies as m 
inner join imdb.genres as g on m.id = g.movie_id
order by  m.`year` desc
limit 15;


///Фильмы без жанра

select 
id,
m.name as name,
g.genre as genre
from imdb.movies as m
left join imdb.genres as g on m.id = g.movie_id
where g.movie_id = 0
order by year desc 
limit 10;

/// Объединение каждой строки таблицы Фильмы с каждой строкой таблицы жанры

select
m.name,
m.id,
g.movie_id,
g.genre
from imdb.movies m 
cross join  imdb.genres as g 
limit 50;

///Найти жанры не используя inner join

select 
m.name as name,
m.id as id,
g.genre as genre
from imdb.movies m
cross join imdb.genres as g 
where m.id = g.movie_id
order by m.year desc
limit 10;



////все актерs и актрисs, снявшиеся в фильме в N году
SELECT
    a.first_name,
    a.last_name
FROM imdb.actors AS a
LEFT SEMI JOIN (
    SELECT r.actor_id
    FROM imdb.roles AS r
    INNER JOIN imdb.movies AS m ON r.movie_id = m.id
    WHERE m.year = 2001
) AS filtered ON a.id = filtered.actor_id
ORDER BY a.first_name ASC
;
///Анти JOIN
SELECT m.name
FROM imdb.movies AS m
LEFT ANTI JOIN imdb.genres AS g ON m.id = g.movie_id
ORDER BY
    m.year DESC,
    m.name ASC
LIMIT 10;


