USE nyc_taxi;

-- The average distance of a trip
SELECT ROUND(AVG(geography_distance(pickup_location, dropoff_location) / 1000), 2) val
FROM trips t, neighborhoods n
WHERE
    n.id IN (
        SELECT id FROM neighborhoods
    ) AND
    GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon);
