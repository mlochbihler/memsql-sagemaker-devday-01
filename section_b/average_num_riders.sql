USE nyc_taxi;

-- The average number of riders per trip
SELECT ROUND(AVG(num_riders), 2) val
FROM trips t, neighborhoods n
WHERE
    status = "completed" AND
    n.id IN (
        SELECT id FROM neighborhoods
    ) AND
    GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon);
