DROP VIEW IF EXISTS enceladus_events;
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