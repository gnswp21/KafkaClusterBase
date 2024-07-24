java openjdk 11

### 카프카 확인
echo "ls /brokers/ids" | /root/kafka/bin/zookeeper-shell.sh mykafka1:2181

bin/kafka-broker-api-versions.sh --bootstrap-server mykafka3:9092


bin/kafka-console-consumer.sh --bootstrap-server mykafka1:9092 --topic hello.kafka\
--from-beginning


bin/kafka-topics.sh --create --topic webtoon-topic \
--bootstrap-server mykafka1:9092, mykafka2:9092, mykafka3:9092 \
--partitions 3 \
--replication-factor 3

rm -rf $KAFKA_HOME/data/meta.properties
tail -f $KAFKA_HOME/logs/server.log
cat $KAFKA_HOME/logs/server.log



