#!/bin/bash

# Substitute environment variables in server.properties
envsubst < /root/kafka/config/server.properties > /root/kafka/config/server.properties.tmp
mv /root/kafka/config/server.properties.tmp /root/kafka/config/server.properties

# Start Kafka server
exec /root/kafka/bin/kafka-server-start.sh /root/kafka/config/server.properties
