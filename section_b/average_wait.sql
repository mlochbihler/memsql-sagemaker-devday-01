use nyc_taxi;

-- The average amount of time between someone requesting a ride and that person being picked up
SELECT ROUND(AVG(pickup_time - request_time) / 60,2) val
FROM trips t, neighborhoods n
WHERE
    n.id IN (
        SELECT id FROM neighborhoods
    ) AND
    GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon) AND
    pickup_time != 0 AND
    request_time != 0;
