use tpch;

CREATE OR REPLACE PIPELINE tpch_100_lineitem
    AS LOAD DATA S3 'memsql-tpch-dataset/sf_100/lineitem/'
    config '{"region":"us-east-1"}'
    SKIP DUPLICATE KEY ERRORS
    INTO TABLE lineitem
    FIELDS TERMINATED BY '|'
    LINES TERMINATED BY '|\n';

CREATE OR REPLACE PIPELINE tpch_100_customer
    AS LOAD DATA S3 'memsql-tpch-dataset/sf_100/customer/'
    config '{"region":"us-east-1"}'
    SKIP DUPLICATE KEY ERRORS
    INTO TABLE customer
    FIELDS TERMINATED BY '|'
    LINES TERMINATED BY '|\n';

CREATE OR REPLACE PIPELINE tpch_100_nation
    AS LOAD DATA S3 'memsql-tpch-dataset/sf_100/nation/'
    config '{"region":"us-east-1"}'
    SKIP DUPLICATE KEY ERRORS
    INTO TABLE nation
    FIELDS TERMINATED BY '|'
    LINES TERMINATED BY '|\n';

CREATE OR REPLACE PIPELINE tpch_100_orders
    AS LOAD DATA S3 'memsql-tpch-dataset/sf_100/orders/'
    config '{"region":"us-east-1"}'
    SKIP DUPLICATE KEY ERRORS
    INTO TABLE orders
    FIELDS TERMINATED BY '|'
    LINES TERMINATED BY '|\n';

CREATE OR REPLACE PIPELINE tpch_100_part
    AS LOAD DATA S3 'memsql-tpch-dataset/sf_100/part/'
    config '{"region":"us-east-1"}'
    SKIP DUPLICATE KEY ERRORS
    INTO TABLE part
    FIELDS TERMINATED BY '|'
    LINES TERMINATED BY '|\n';

CREATE OR REPLACE PIPELINE tpch_100_partsupp
    AS LOAD DATA S3 'memsql-tpch-dataset/sf_100/partsupp/'
    config '{"region":"us-east-1"}'
    SKIP DUPLICATE KEY ERRORS
    INTO TABLE partsupp
    FIELDS TERMINATED BY '|'
    LINES TERMINATED BY '|\n';

CREATE OR REPLACE PIPELINE tpch_100_region
    AS LOAD DATA S3 'memsql-tpch-dataset/sf_100/region/'
    config '{"region":"us-east-1"}'
    SKIP DUPLICATE KEY ERRORS
    INTO TABLE region
    FIELDS TERMINATED BY '|'
    LINES TERMINATED BY '|\n';

CREATE OR REPLACE PIPELINE tpch_100_supplier
    AS LOAD DATA S3 'memsql-tpch-dataset/sf_100/supplier/'
    config '{"region":"us-east-1"}'
    SKIP DUPLICATE KEY ERRORS
    INTO TABLE supplier
    FIELDS TERMINATED BY '|'
    LINES TERMINATED BY '|\n';
