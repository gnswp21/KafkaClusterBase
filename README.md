java openjdk 11

### 카프카 확인
echo "ls /brokers/ids" | /root/kafka/bin/zookeeper-shell.sh mykafka1:2181

bin/kafka-broker-api-versions.sh --bootstrap-server mykafka3:9092


bin/kafka-console-consumer.sh --bootstrap-server mykafka1:9092 --topic hello.kafka\
--from-beginning


bin/kafka-topics.sh --create --topic webtoon-topic \
--bootstrap-server kafka-0.kafka-svc-domain.default.svc.cluster.local:9092, kafka-1.kafka-svc-domain.default.svc.cluster.local:9092, kafka-2.kafka-svc-domain.default.svc.cluster.local:9092 \
--partitions 3 \
--replication-factor 3

rm -rf $KAFKA_HOME/data/meta.properties
tail -f $KAFKA_HOME/logs/server.log
cat $KAFKA_HOME/logs/server.log

<statefulset_name>-<pod_ordinal>.<headless_service_name>.<namespace>.svc.cluster.local

kafka-0.kafka-svc-domain.default.svc.cluster.local


