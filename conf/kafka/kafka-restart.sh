for i in 1 2 3; do
  host="mykafka$i"
  ssh $host "sh /root/kafka/bin/zookeeper-server-stop.sh"
  ssh $host "sh /root/kafka/bin/kafka-server-stop.sh"

  ssh $host "sh /root/kafka/bin/zookeeper-server-start.sh -daemon /root/kafka/config/zookeeper.properties"
  ssh $host "sh /root/kafka/bin/kafka-server-start.sh -daemon /root/kafka/config/server.properties"
done
