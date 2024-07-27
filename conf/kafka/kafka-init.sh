#!/bin/bash

# Substitute environment variables in server.properties
echo temp >> /root/kafka/config/server.properties
echo ${KAFKA_ZOOKEEPER_CONNECT}
# Start Kafka server
exec /root/kafka/bin/kafka-server-start.sh /root/kafka/config/server.properties
