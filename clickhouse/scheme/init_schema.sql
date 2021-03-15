-- Create MergeTree table
DROP TABLE IF EXISTS access_logs;
CREATE TABLE access_logs
(
    `request_id` String,
    `timestamp` DateTime,
    `remote_user` String,
    `remote_addr` String,
    `scheme` String,
    `host` String,
    `server_addr` String,
    `request_method` String,
    `request_uri` String,
    `request_length` UInt32,
    `request_time` Float64,
    `status` UInt16,
    `body_bytes_sent` UInt32,
    `upstream_addr` String,
    `upstream_status` String,
    `upstream_response_time` Float64
)
ENGINE = MergeTree
PARTITION BY toDate(timestamp)
ORDER BY (timestamp, host)
TTL timestamp + toIntervalWeek(1)
SETTINGS index_granularity = 8192;

-- Create Kafka Engine
DROP TABLE IF EXISTS `.access_logs_kafka`;
CREATE TABLE `.access_logs_kafka`
(
    `request_id` String,
    `timestamp` DateTime,
    `remote_user` String,
    `remote_addr` String,
    `scheme` String,
    `host` String,
    `server_addr` String,
    `request_method` String,
    `request_uri` String,
    `request_length` UInt32,
    `request_time` Float64,
    `status` UInt16,
    `body_bytes_sent` UInt32,
    `upstream_addr` String,
    `upstream_status` String,
    `upstream_response_time` String
)
ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka:9092', kafka_topic_list = 'access-logs', kafka_group_name = 'access-logs-consumer', kafka_format = 'JSONEachRow', kafka_row_delimiter = '\n', kafka_schema = '', kafka_num_consumers = 1, kafka_skip_broken_messages = 1;

-- Create materialized view
DROP TABLE IF EXISTS `.mv_access_logs`;
CREATE MATERIALIZED VIEW `.mv_access_logs` TO default.access_logs
(
    `request_id` String,
    `timestamp` DateTime,
    `remote_user` String,
    `remote_addr` String,
    `scheme` String,
    `host` String,
    `server_addr` String,
    `request_method` String,
    `request_uri` String,
    `request_length` UInt32,
    `request_time` Float64,
    `status` UInt16,
    `body_bytes_sent` UInt32,
    `upstream_addr` String,
    `upstream_status` String,
    `upstream_response_time` Float64
) AS
SELECT
    request_id,
    timestamp,
    remote_user,
    remote_addr,
    if(scheme = '', 'unknown', scheme) AS scheme,
    host,
    server_addr,
    if(request_method = '', 'UNKNOWN', request_method) AS request_method,
    request_uri,
    request_length,
    request_time,
    status,
    body_bytes_sent,
    upstream_addr,
    upstream_status,
    toFloat64OrZero(upstream_response_time) AS upstream_response_time
FROM default.`.access_logs_kafka`;
