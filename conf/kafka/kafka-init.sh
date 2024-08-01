#!/bin/bash

cat <<EOF > /root/kafka/config/server.properties
broker.id=${KAFKA_BROKER_ID}
zookeeper.connect=${KAFKA_ZOOKEEPER_CONNECT}
listeners=${KAFKA_LISTENERS}
advertised.listeners=${KAFKA_ADVERTISED_LISTENERS}
listener.security.protocol.map=${KAFKA_LISTENER_SECURITY_PROTOCOL_MAP}
inter.broker.listener.name=${KAFKA_INTER_BROKER_LISTENER_NAME}
log.dirs=${KAFKA_LOG_DIRS}
auto.create.topics.enable=${KAFKA_AUTO_CREATE_TOPICS_ENABLE}
EOF

# Substitute environment variables in server.properties
envsubst < /root/kafka/config/server.properties > /root/kafka/config/server.properties.tmp
mv /root/kafka/config/server.properties.tmp /root/kafka/config/server.properties

# Start Kafka server
exec /root/kafka/bin/kafka-server-start.sh /root/kafka/config/server.properties
