DROP TABLE IF EXISTS flybys;

CREATE TABLE flybys (
    id INT PRIMARY KEY,
    name TEXT NOT NULL,
    date DATE NOT NULL,
    altitude NUMERIC(7,1),
    speed NUMERIC(7,1)
);


-- everything below from the first attempt using INMS data 
-- DROP TABLE IF EXISTS flybys;

-- -- load table with CTE that uses low_time function
-- -- note that the version that calcs all the nadirs in one go instead of running a func/separate query for each is faster, but this is clearer
-- WITH lows_by_week AS (
--     SELECT 
--         year,
--         week,
--         MIN(altitude) AS altitude
--     FROM flyby_altitudes
--     GROUP BY year, week
-- ), nadirs AS (
--     SELECT
--         low_time(altitude, year, week) AS time_stamp,
--         lows_by_week.altitude
--     FROM lows_by_week
-- )
-- SELECT 
--     nadirs.*,
--     -- initial values are null
--     null::varchar AS name,
--     null::timestamptz AS start_time,
--     null::timestamptz AS end_time
-- -- SELECT .. INTO creates a new table populated by the SELECT (diff from INSERT INTO which doesn't create a table)
-- INTO flybys 
-- FROM nadirs;

-- -- add primary key (why not do it when creating the table? maybe because we're using INTO?)
-- ALTER TABLE flybys ADD COLUMN id SERIAL PRIMARY KEY;

-- -- using the key, create the name using the new ID
-- -- [] concats strings and also coerces to string
-- UPDATE flybys SET NAME='E-' || id-1;

-- -- add trig calcs
-- ALTER TABLE flybys
-- ADD speed_kms NUMERIC(10,3),
-- ADD target_altitude NUMERIC(10,3),
-- ADD transit_distance NUMERIC(10,3);

-- UPDATE flybys
-- SET target_altitude = (
--     (altitude + 252) / sind(73) - 252
-- );

-- UPDATE flybys
-- SET transit_distance = (
--     (target_altitude + 252) * sind(17) * 2
-- );
-- end comment for first flyby attempt w/ INMS data

