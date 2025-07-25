DROP TABLE IF EXISTS flybys;

-- load table with CTE that uses low_time function
-- note that the version that calcs all the nadirs in one go instead of running a func/separate query for each is faster, but this is clearer
WITH lows_by_week AS (
    SELECT 
        year,
        week,
        MIN(altitude) AS altitude
    FROM flyby_altitudes
    GROUP BY year, week
), nadirs AS (
    SELECT
        low_time(altitude, year, week) AS nadir,
        lows_by_week.altitude
    FROM lows_by_week
)
SELECT 
    nadirs.*,
    -- initial values are null
    null::varchar AS name,
    null::timestamptz AS start_time,
    null::timestamptz AS end_time
-- SELECT .. INTO creates a new table populated by the SELECT (diff from INSERT INTO which doesn't create a table)
INTO flybys 
FROM nadirs
ORDER BY nadir;

-- add primary key (why not do it when creating the table?)
ALTER TABLE flybys ADD COLUMN id SERIAL PRIMARY KEY;

-- using the key, create the name using the new ID
-- [] concats strings and also coerces to string
UPDATE flybys SET NAME='E-' || id-1;
