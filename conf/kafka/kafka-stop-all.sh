for i in 1 2 3; do
  host="mykafka$i"
  ssh $host "sh /root/kafka/bin/kafka-server-stop.sh"
done
for i in 1 2 3; do
  host="mykafka$i"
  ssh $host "sh /root/kafka/bin/zookeeper-server-stop.sh"
done

