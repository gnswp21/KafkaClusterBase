for i in 0 1 2; do
  host="kafka-$i.kafka-svc-domain.default.svc.cluster.local"
  ssh -o StrictHostKeyChecking=no $host echo "\"broker.id=$i\" >> /root/kafka/config/server.properties"
  ssh $host mkdir -p /root/kafka/zookeeper
  ssh $host echo "\"$((i + 1))\" > /root/kafka/zookeeper/myid"

  ssh $host "sh /root/kafka/bin/zookeeper-server-start.sh -daemon /root/kafka/config/zookeeper.properties"
done
echo 'sleep 20sec to activate zookeeper normally'
sleep 20

for i in 0 1 2; do
  host="kafka-$i.kafka-svc-domain.default.svc.cluster.local"
  ssh $host "sh /root/kafka/bin/kafka-server-start.sh -daemon /root/kafka/config/server.properties"
done


#for i in 0 1 2; do
#  host="kafka-$i.kafka-svc-domain.default.svc.cluster.local"
#  echo $host
#  ssh $host jps -m
#  echo "ls /brokers/ids" | /root/kafka/bin/zookeeper-shell.sh $host:2181
#done

