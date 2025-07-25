DROP FUNCTION IF EXISTS low_time(NUMERIC, DOUBLE PRECISION, DOUBLE PRECISION);
CREATE FUNCTION low_time (
    alt NUMERIC,
    yr DOUBLE PRECISION,
    wk DOUBLE PRECISION,
    out TIMESTAMP WITHOUT TIME ZONE
) AS $$
    SELECT
        MIN(time_stamp) + ((MAX(time_stamp) - MIN(time_stamp)) / 2) AS nadir
    FROM flyby_altitudes
    WHERE flyby_altitudes.altitude = alt
        AND flyby_altitudes.year = yr
        AND flyby_altitudes.week = wk
$$ language sql;
