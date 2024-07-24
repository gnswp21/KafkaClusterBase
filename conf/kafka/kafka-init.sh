for i in 1 2 3; do
  host="mykafka$i"

  ssh -o StrictHostKeyChecking=no $host echo "\"broker.id=$i\" >> /root/kafka/config/server.properties"
  ssh $host mkdir -p /var/lib/zookeeper
  ssh $host echo "\"$i\" > /var/lib/zookeeper/myid"

  ssh $host "sh /root/kafka/bin/zookeeper-server-start.sh -daemon /root/kafka/config/zookeeper.properties"
  ssh $host "sh /root/kafka/bin/kafka-server-start.sh -daemon /root/kafka/config/server.properties"
done
