USE nyc_taxi;

-- Total number of trips for each neighborhood
SELECT COUNT(*) num_rides, n.name
FROM trips t, neighborhoods n
WHERE
    n.id IN (
    	SELECT id FROM neighborhoods
    ) AND
    GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon)
GROUP BY n.name
ORDER BY num_rides DESC;
