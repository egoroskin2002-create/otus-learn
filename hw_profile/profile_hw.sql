CREATE TABLE youtube_dislikes
(
    `id` String,
    `fetch_date` String,
    `upload_date` String,
    `title` String,
    `uploader_id` String,
    `uploader` String,
    `uploader_sub_count` Int64,
    `is_age_limit` Bool,
    `view_count` Int64,
    `like_count` Int64,
    `dislike_count` Int64,
    `is_crawlable` Bool,
    `is_live_content` Bool,
    `has_subtitles` Bool,
    `is_ads_enabled` Bool,
    `is_comments_enabled` Bool,
    `description` String,
    `rich_metadata` Array(Map(String, String)),
    `super_titles` Array(Map(String, String)),
    `uploader_badges` String,
    `video_badges` String
)
ENGINE = MergeTree
ORDER BY (upload_date, uploader_id);

INSERT INTO youtube_dislikes
SELECT *
FROM s3(
    'https://clickhouse-public-datasets.s3.amazonaws.com/youtube/original/files/*.zst',
    'JSONLines'
);

select * from `default`.youtube_dislikes yd ;

SELECT
    partition_key,
    sorting_key,
    primary_key,
    table
FROM system.tables
WHERE table = 'youtube_dislikes';

select count(), sum(like_count)
from `default`.youtube_dislikes yd 
where view_count > 1000000 ;

Explain indexes = 1 
select count(), sum(like_count)
from `default`.youtube_dislikes yd 
where view_count > 1000000;

--Explain indexes = 1
select count(), sum(like_count) from default.youtube_dislikes 
where upload_date >= '20210101' and upload_date <= '20211231';





