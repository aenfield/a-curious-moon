-- enceladus_events
DROP MATERIALIZED VIEW IF EXISTS enceladus_events;
CREATE MATERIALIZED VIEW enceladus_events AS
SELECT
    events.id,
    events.title,
    events.description,
    events.time_stamp,
    events.time_stamp::date AS DATE,
    event_types.description AS event,
    to_tsvector(
        concat(events.description, '', events.title)
    ) AS search
FROM events
INNER JOIN event_types
    ON event_types.id = event_type_id
WHERE target_id = 28 
ORDER BY events.time_stamp;

CREATE INDEX idx_event_search ON enceladus_events using GIN(search);

-- flyby_altitudes (from INMS data)
DROP MATERIALIZED VIEW IF EXISTS flyby_altitudes;
CREATE MATERIALIZED VIEW flyby_altitudes AS
SELECT
    (sclk::timestamp) AS time_stamp,
    alt_t::numeric(10, 3) AS altitude
FROM import.inms
WHERE target='ENCELADUS'
    AND alt_t IS NOT NULL;
