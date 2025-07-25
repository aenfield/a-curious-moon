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

DROP FUNCTION IF EXISTS pythag(NUMERIC, NUMERIC, NUMERIC);
CREATE FUNCTION pythag(
    x NUMERIC,
    y NUMERIC,
    z NUMERIC,
    out NUMERIC
) AS $$
SELECT
    SQRT(
        (x ^ 2) + (y ^ 2) + (z ^ 2)
    )::numeric(10,2);
$$ language sql;