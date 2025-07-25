-- CDA
DROP SCHEMA IF EXISTS cda CASCADE;

CREATE SCHEMA cda;

SELECT 
    event_id::integer AS event_id,
    impact_event_time::timestamp AS time_stamp,
    impact_event_time::date AS impact_date,
    CASE counter_number
        WHEN '**' THEN NULL
        ELSE counter_number::integer
    END AS counter,
    spacecraft_sun_distance::numeric(6,4) AS sun_distance_au,
    spacecraft_saturn_distance::numeric(8,2) AS saturn_distance_rads,
    spacecraft_x_velocity::numeric(6,2) AS x_velocity,
    spacecraft_y_velocity::numeric(6,2) AS y_velocity,
    spacecraft_z_velocity::numeric(6,2) AS z_velocity,
    particle_charge::numeric(4,1),
    particle_mass::numeric(4,1)
INTO cda.impacts
FROM import.cda
ORDER BY impact_event_time::timestamp;

ALTER TABLE cda.impacts ADD id SERIAL PRIMARY KEY;


