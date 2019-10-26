DROP DATABASE IF EXISTS nyc_taxi;
CREATE DATABASE nyc_taxi;
USE nyc_taxi;

CREATE TABLE drivers (
    id bigint(20) NOT NULL,
    first_name varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
    last_name varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
    location geographypoint NOT NULL,
    goal_location geographypoint DEFAULT NULL,
    status varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
    trip_id bigint(20) DEFAULT -1,
    PRIMARY KEY (id),
    KEY location (location)
);

CREATE TABLE neighborhoods (
    id bigint(20) NOT NULL,
    name varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
    borough varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
    polygon geography DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE trips (
  id bigint(20) NOT NULL,
  status varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  pickup_location geographypoint NOT NULL DEFAULT 'Point(0 0)',
  dropoff_location geographypoint NOT NULL DEFAULT 'Point(0 0)',
  request_time int(11) DEFAULT NULL,
  request_attempts int(11) NOT NULL DEFAULT 1,
  accept_time int(11) DEFAULT NULL,
  pickup_time int(11) DEFAULT NULL,
  dropoff_time int(11) DEFAULT NULL,
  num_riders int(11) DEFAULT NULL,
  price int(11) DEFAULT NULL,
  driver_id bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS triptotals (
num_rides bigint(20) DEFAULT NULL,
name varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
SHARD KEY (name)
);
 
CREATE TABLE IF NOT EXISTS avgwait_passenger (
avgwait_p DECIMAL(8,2) UNSIGNED DEFAULT NULL
);
 
CREATE TABLE IF NOT EXISTS avgdist (
avgdist DECIMAL(8,2) UNSIGNED DEFAULT NULL
);
 
CREATE TABLE IF NOT EXISTS avgridetime (
avgridet DECIMAL(8,2) UNSIGNED DEFAULT NULL
);
 
CREATE TABLE IF NOT EXISTS avgcost (
avgcost DECIMAL(8,2) UNSIGNED DEFAULT NULL
);
 
CREATE TABLE IF NOT EXISTS avgwait_driver (
avgwait_d DECIMAL(8,2) UNSIGNED DEFAULT NULL
);
 
CREATE TABLE IF NOT EXISTS avgriders (
avgriders DECIMAL(8,2) UNSIGNED DEFAULT NULL
);
 
CREATE TABLE IF NOT EXISTS triptotalsc (
num_rides bigint(20) DEFAULT NULL,
name varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
SHARD KEY (name)
);
 
CREATE TABLE nab_nyctaxi_scored (
     time_id CHAR(19) NOT NULL DEFAULT '2018-01-01 00:00:00',
     num_riders INT(11) DEFAULT 0,
     anomaly_score DECIMAL(7,5) DEFAULT 0.00,
     PRIMARY KEY (time_id)
);
