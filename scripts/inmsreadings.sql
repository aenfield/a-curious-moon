DROP SCHEMA IF EXISTS inms CASCADE;
CREATE SCHEMA inms;

ALTER TABLE chem_data SET SCHEMA inms;

DROP TABLE IF EXISTS inms.readings;
SELECT
    sclk::TIMESTAMP AS time_stamp,
    source::TEXT,
    mass_table,
    alt_t::NUMERIC(9,2) AS altitude,
    mass_per_charge::NUMERIC(6,3),
    p_energy::NUMERIC(7,3),
    pythag(
        sc_vel_t_scx::NUMERIC,
        sc_vel_t_scy::NUMERIC,
        sc_vel_t_scz::NUMERIC
    ) AS relative_speed,
    c1counts::INTEGER AS high_counts,
    c2counts::INTEGER AS low_counts
INTO inms.readings
FROM import.inms
ORDER BY time_stamp;

ALTER TABLE inms.readings ADD id SERIAL PRIMARY KEY;

CREATE INDEX CONCURRENTLY idx_stamps 
    ON inms.readings(time_stamp) 
    WHERE altitude IS NOT NULL;

