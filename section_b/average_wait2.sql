USE nyc_taxi;

-- The average amount of time it takes from the time a driver accepts a ride to the time they pick up the passenger
SELECT ROUND(AVG(pickup_time - accept_time) / 60, 2) val
FROM trips t, neighborhoods n
WHERE
    pickup_time != 0 AND
    accept_time != 0 AND
    n.id IN (
        SELECT id FROM neighborhoods
    ) AND
    GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon);
