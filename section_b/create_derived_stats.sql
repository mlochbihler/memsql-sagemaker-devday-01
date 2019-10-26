USE nyc_taxi;

delimiter //
CREATE or replace PROCEDURE `derive_stats` (i int)
AS
declare x int;
begin

DELETE FROM avgcost;
DELETE FROM avgdist;
DELETE FROM avgriders;
DELETE FROM avgridetime;
DELETE FROM avgwait_driver;
DELETE FROM avgwait_passenger;

INSERT INTO avgcost VALUES (0);
INSERT INTO avgdist VALUES (0);
INSERT INTO avgriders VALUES (0);
INSERT INTO avgridetime VALUES (0);
INSERT INTO avgwait_driver VALUES (0);
INSERT INTO avgwait_passenger VALUES (0);

while True loop

    echo select concat(current_timestamp,": deriving stats") as "stats";

-- INSERT INTO temp table triptotalsc then UPDATE triptotals 
-- Total number of trips for each neighborhood
    DELETE FROM triptotalsc; 
    INSERT INTO triptotalsc
    	SELECT COUNT(*) num_rides, n.name
       	FROM trips t, neighborhoods n
      	 WHERE n.id IN (SELECT id 
                                    FROM neighborhoods) AND
       		      GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon)
       	GROUP BY n.name
        ORDER BY num_rides DESC;

       UPDATE triptotals t, triptotalsc tc
       SET t.num_rides = tc.num_rides
       WHERE t.name = tc.name;

-- UPDATE avgwait_passenger
-- The average amount of time between someone requesting a ride and that person being picked up     
     	UPDATE avgwait_passenger
     	SET avgwait_p = (SELECT ROUND(AVG(pickup_time - request_time) / 60,2) val
        	 FROM trips t, neighborhoods n
         WHERE n.id IN (SELECT id 
			           FROM neighborhoods) AND
        	              GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon) AND
        		      pickup_time != 0 AND
        		      request_time != 0); 

-- UPDATE avgdist
-- The average distance of a trip
	UPDATE avgdist
        	SET avgdist =(SELECT ROUND(AVG(geography_distance(pickup_location, dropoff_location) / 1000), 2) val
	FROM trips t, neighborhoods n
	WHERE n.id IN (SELECT id 
				  FROM neighborhoods) AND
		     GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon));
   
-- UPDATE avgridetime
-- The average amount of time between someone being picked up and that person being dropped off
	UPDATE avgridetime
	SET avgridet = (SELECT ROUND(AVG(dropoff_time - pickup_time) / 60, 2) val
	FROM trips t, neighborhoods n
	WHERE status = "completed" AND
		      n.id IN (SELECT id 
				  FROM neighborhoods) AND
		      GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon));

-- UPDATE avgcost
-- The average cost of a trip
	UPDATE avgcost
	SET avgcost = (SELECT ROUND(AVG(price), 2) val
	FROM trips t, neighborhoods n
	WHERE status = "completed" AND
		     n.id IN (SELECT id 
                                   FROM neighborhoods) AND
		     GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon));

-- UPDATE avgwait_driver
-- The average amount of time it takes from the time a driver accepts a ride to the time they pick up the passenger
	UPDATE avgwait_driver
	SET avgwait_d = (SELECT ROUND(AVG(pickup_time - accept_time) / 60, 2) val
	FROM trips t, neighborhoods n
	WHERE pickup_time != 0 AND
	             accept_time != 0 AND n.id IN (SELECT id 
								      FROM neighborhoods) AND
	             GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon));

-- UPDATE avgriders
-- The average number of riders per trip
	UPDATE avgriders
	SET avgriders = (SELECT ROUND(AVG(num_riders), 2) val
	FROM trips t, neighborhoods n
	WHERE status = "completed" AND
		      n.id IN (SELECT id 
 				  FROM neighborhoods) AND
		      GEOGRAPHY_INTERSECTS(t.pickup_location, n.polygon));
    x = sleep(i);
end loop;
end;
//
delimiter ;
