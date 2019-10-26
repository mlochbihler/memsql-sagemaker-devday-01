USE nyc_taxi;

-- The average amount of time between someone being picked up and that person being dropped off
SELECT ROUND(AVG(dropoff_time - pickup_time) / 60, 2) val
FROM trips t, neighborhoods n
WHERE
    status = "completed" AND
    n.id IN (
        SELECT id FROM neighborhoods
    ) AND
    GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon);
