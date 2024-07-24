for i in 1 2 3; do
  host="mykafka$i"
  ssh -o StrictHostKeyChecking=no $host "sh /root/kafka/bin/zookeeper-server-start.sh -daemon /root/kafka/config/zookeeper.properties"
done
echo 'sleep 20sec to activate zookeeper normally'
sleep 20

for i in 1 2 3; do
  host="mykafka$i"
  ssh $host "sh /root/kafka/bin/kafka-server-start.sh -daemon /root/kafka/config/server.properties"
done

for i in 1 2 3; do
  host="mykafka$i"
  echo $host
  ssh $host jps -m
  echo "ls /brokers/ids" | /root/kafka/bin/zookeeper-shell.sh $host:2181
done