use nyc_taxi;

CREATE PIPELINE nab_nyctaxi_scored
 AS LOAD DATA S3 'lochbihler/nyctaxi/'
 WITH TRANSFORM ('file:///home/memsql/score_riders.py', '', '')
 SKIP DUPLICATE KEY ERRORS
INTO TABLE nab_nyctaxi_scored
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';
