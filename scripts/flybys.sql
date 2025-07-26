-- flybys table is created in import.sql and loaded in the import make target
-- this is all the follow-on stuff (i.e., if you need to re-run this, you need
-- drop/recreate the table in import.sql and then load the flyby data from the JPL)

-- 'sort of temp table'
DROP TABLE IF EXISTS time_altitudes;
SELECT
    sclk::timestamp AS time_stamp,
    alt_t::numeric(9,2) AS altitude,
    DATE_PART('year', sclk::timestamp) AS year,
    DATE_PART('week', sclk::timestamp) AS week
INTO time_altitudes
FROM import.inms    
WHERE target = 'ENCELADUS'
    AND alt_t IS NOT NULL;

WITH mins AS (
    SELECT
        MIN(altitude) AS nadir,
        year,
        week
    FROM time_altitudes
    GROUP BY year, week
    ORDER BY year, week
), min_times AS (
    SELECT
        mins.*,
        min(time_stamp) AS low_time,
        min(time_stamp) - interval '20 seconds' AS window_start,
        min(time_stamp) + interval '20 seconds' AS window_end
    FROM mins
    INNER JOIN time_altitudes ta 
        ON mins.year = ta.year
        AND mins.week = ta.week
        AND mins.nadir = ta.altitude
    GROUP BY mins.week, mins.year, mins.nadir
), fixed_flybys AS (
    SELECT
        f.id,
        f.name,
        f.date,
        f.altitude,
        f.speed,
        mt.nadir,
        mt.year,
        mt.week,
        mt.low_time,
        mt.window_start,
        mt.window_end
    FROM flybys f
    INNER JOIN min_times mt 
        ON DATE_PART('year', f.date) = mt.year 
        AND DATE_PART('week', f.date) = mt.week
)
SELECT
    *
INTO flybys_2
FROM fixed_flybys
ORDER BY date;

ALTER TABLE flybys_2 ADD PRIMARY KEY (id);

DROP TABLE flybys CASCADE;
DROP TABLE time_altitudes;

ALTER TABLE flybys_2 RENAME TO flybys;

ALTER TABLE flybys ADD targeted BOOLEAN NOT NULL DEFAULT false;

UPDATE flybys SET targeted=true WHERE id in (3,5,7,17,18,21);