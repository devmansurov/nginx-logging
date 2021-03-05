DROP TABLE IF EXISTS default.logs;
CREATE TABLE logs(
    server_name String,
    request String,
    http_user_agent String,
    http_host String,
    request_uri String,
    scheme String,
    request_method String,
    request_length Int16,
    request_time Float32,
    http_referer String,
    status Int16,
    body_bytes_sent Int16,
    sent_http_content_type String,
    remote_addr String,
    remote_port String,
    remote_user String,
    upstream_addr String,
    upstream_bytes_received Int16,
    upstream_bytes_sent Int16,
    upstream_cache_status String,
    upstream_connect_time Float32,
    upstream_header_time Float32,
    upstream_response_length Int16,
    upstream_response_time Float32,
    upstream_status Int16,
    upstream_http_content_type String,
    timestamp DateTime('UTC')
) ENGINE = MergeTree()
    PARTITION BY toYYYYMMDD(timestamp)
    ORDER BY timestamp
    TTL timestamp + toIntervalMonth(1);