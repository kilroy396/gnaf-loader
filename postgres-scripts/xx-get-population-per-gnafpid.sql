
-- Import MB counts CSV file
DROP TABLE IF EXISTS testing.mb_2016_counts;
CREATE TABLE testing.mb_2016_counts (
    mb_2016_code bigint,
    mb_category_name_2016 text NOT NULL,
    area_albers_sqkm double precision,
    dwelling integer default 0,
    person integer default 0,
	address_count integer default 0,
    state smallint NOT NULL,
    geom geometry(MultiPolygon, 4283),
    CONSTRAINT abs_2011_mb_pk PRIMARY KEY (mb_2016_code)
);

COPY testing.mb_2016_counts (mb_2016_code, mb_category_name_2016, area_albers_sqkm, dwelling, person, state)
FROM '/Users/hugh.saalmans/Downloads/2016 census mesh block counts.csv' WITH (FORMAT CSV, HEADER);

ANALYSE testing.mb_2016_counts;

-- Get address counts per meshblock -- 1 min
WITH counts AS (
	SELECT mb_2016_code,
		   count(*) AS address_count
	FROM gnaf_201911.address_principals
	GROUP BY mb_2016_code
)
UPDATE testing.mb_2016_counts AS mb
  SET address_count = counts.address_count
  FROM counts
  WHERE mb.mb_2016_code = counts.mb_2016_code
;

ANALYSE testing.mb_2016_counts;

-- add geoms
UPDATE testing.mb_2016_counts AS mb
  SET geom = bdys.geom
  FROM admin_bdys_201911.abs_2016_mb as bdys
  WHERE mb.mb_2016_code = bdys.mb_16code::bigint;

ANALYSE testing.mb_2016_counts;

CREATE INDEX mb_2016_counts_geom_idx ON testing.mb_2016_counts USING gist(geom);
ALTER TABLE testing.mb_2016_counts CLUSTER ON mb_2016_counts_geom_idx;


-- get the correct number of addresses from GNAF for each meshblock -- 10 mins

--    1. where address count is greater than dwelling count
DROP TABLE IF EXISTS testing.address_principals_dwelling;
CREATE TABLE testing.address_principals_dwelling AS
WITH adr AS (
	SELECT gnaf.gnaf_pid,
           gnaf.mb_2016_code,
	       mb.dwelling,
	       mb.person,
           mb.address_count,
           gnaf.geom
	FROM gnaf_201911.address_principals as gnaf
	INNER JOIN testing.mb_2016_counts AS mb on gnaf.mb_2016_code = mb.mb_2016_code
	WHERE mb.address_count >= mb.dwelling
), rows as (
    SELECT *, row_number() OVER (PARTITION BY mb_2016_code ORDER BY random()) as row_num
    FROM adr
)
SELECT gnaf_pid,
	   mb_2016_code,
	   address_count,
	   dwelling,
	   person,
	   'under addresses'::text as dwelling_count_type,
	   geom
FROM rows
WHERE row_num <= dwelling
ORDER BY mb_2016_code,
         row_num
;

ANALYSE testing.address_principals_dwelling;

--    2. where address count is less than dwelling count
INSERT INTO testing.address_principals_dwelling
WITH adr AS (
	SELECT gnaf.gnaf_pid,
           gnaf.mb_2016_code,
	       mb.dwelling,
	       mb.person,
           mb.address_count,
           gnaf.geom,
		   generate_series(1, ceiling(dwelling::float / address_count::float)::integer) as duplicate_number
	FROM gnaf_201911.address_principals as gnaf
	INNER JOIN testing.mb_2016_counts AS mb on gnaf.mb_2016_code = mb.mb_2016_code
	WHERE mb.address_count < mb.dwelling
	--and mb.mb_2016_code = 11205625300
	order by gnaf.mb_2016_code, gnaf.gnaf_pid, duplicate_number
), rows as (
    SELECT *, row_number() OVER (PARTITION BY mb_2016_code ORDER BY duplicate_number, random()) as row_num
    FROM adr
)
SELECT gnaf_pid,
	   mb_2016_code,
	   address_count,
	   dwelling,
	   person,
	   'over addresses' as dwelling_count_type,
	   geom
FROM rows
WHERE row_num <= dwelling
ORDER BY mb_2016_code,
         row_num
;

ANALYSE testing.address_principals_dwelling;

--   3. add random points in meshblocks that have no addresses (8,903 dwellings affected)
INSERT INTO testing.address_principals_dwelling
SELECT 'MB' || mb_2016_code::text || '_' || (row_number() OVER ())::text as gnaf_pid,
	   mb_2016_code,
	   address_count,
	   dwelling,
	   person,
	   'no addresses' as dwelling_count_type,
	   ST_RandomPointsInPolygon(geom, dwelling) as geom
FROM testing.mb_2016_counts
WHERE geom is not null
AND address_count = 0
AND dwelling > 0
;

ANALYSE testing.address_principals_dwelling;


CREATE INDEX basic_address_principals_dwelling_geom_idx ON testing.address_principals_dwelling USING gist (geom);
ALTER TABLE testing.address_principals_dwelling CLUSTER ON basic_address_principals_dwelling_geom_idx;

CREATE INDEX basic_address_principals_dwelling_mb_2016_code_idx ON testing.address_principals_dwelling USING btree(mb_2016_code);


-- QA
select sum(dwelling) from testing.mb_2016_counts where geom is not null; -- 9913151

select sum(dwelling) from testing.mb_2016_counts where geom is null; -- 286

select sum(dwelling) from testing.mb_2016_counts where geom is not null and address_count = 0 -- 9189

select sum(dwelling) from testing.mb_2016_counts where geom is not null and address_count > 0; -- 9904248

select count(*) from testing.address_principals_dwelling; -- 9904248

select * from testing.mb_2016_counts
where mb_2016_code NOT IN (select distinct mb_2016_code from testing.address_principals_dwelling)
and geom is not null
and dwelling > 0;

-- TO DO
-- random points in MBs where address_count = 0






-- 32509 MBs with less addresses than dwellings
SELECT count(*) as cnt,
       avg(dwelling - address_count),
	   max(dwelling - address_count)
FROM testing.mb_2016_counts
WHERE address_count < dwelling;

select *, dwelling - address_count as extra_dwellings
FROM testing.mb_2016_counts
WHERE address_count < dwelling
order by extra_dwellings desc;

-- -- 269858 MBs with more addresses than dwellings
-- SELECT count(*) FROM testing.mb_2016_counts
-- WHERE address_count > dwelling;

-- -- 15363 MBs with the same address count as dwellings
-- SELECT count(*) FROM testing.mb_2016_counts
-- WHERE address_count = dwelling;
