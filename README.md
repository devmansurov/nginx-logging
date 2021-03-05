# nginx-logging

Docker-based stack for access logs processing.

### Stack

- Nginx (reverse-proxy)
- Logstash (log processor)
- Kafka (messages broker)
- Zookeeper (distributed coordinator)
- ClickHouse (OLAP database)

### Getting started

Run stack.

```
docker-compose up -d
```

Run HTTP requests loop.

```
while : ; do
  sleep 1;
  curl -sL http://127.0.0.1:4040 -o /dev/null;
  echo -n "."
done
```

Execute query.

```
echo 'SELECT COUNT(*) FROM access_logs;' | curl 'http://localhost:8123/' --data-binary @-
```

Done.

### Troubleshooting

Monitor requests in access logs.

```bash
docker-compose logs -f nginx
```

Watch logs in Logstash console.

```bash
docker-compose logs -f logstash
```

Run Kafka consumer to read messages.

```bash
docker-compose exec kafka /opt/bitnami/kafka/bin/kafka-console-consumer.sh \
  --bootstrap-server kafka:9092 \
  --topic access-logs \
  --from-beginning
```

Fetch records from Kafka Engine and commit offset.

```bash
echo 'SELECT COUNT(*) FROM `.access_logs_kafka`;' | curl 'http://localhost:8123/' --data-binary @-
```

Monitor ClickHouse errors in console.

```bash
docker-compose logs -f clickhouse
```

