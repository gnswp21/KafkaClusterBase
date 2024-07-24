# 개요

도커 컨테이서 주키퍼 앙상블을 이용해 3개의 브로커로 이루어진 카프카 클러스터를 구성하는 최소 세팅 예시입니다.

# 구조

## 자바, SSH, 카프카 설치 및 환경변수 설정

`conf/java/Dockerfile-java, conf/ssh/Dockerfile-ssh,  conf/kafka/Dockerfile-kafka` 을 통해 자바, ssh, 카프카를 우분투에 다운 받고 설치합니다.

## 카프카, 주키퍼 설정

클러스터에 주효한 설정

- server.properties

```docker
log.dirs=/root/kafka/data
zookeeper.connect=mykafka1:2181,mykafka2:2181,mykafka3:2181
```

`zookeeper.connect` 주키퍼 서버에 연결되는 호스트와 포트를 모두 적어줌으로써  각각의 카프카 브로커를 주키퍼 앙상블에 연결합니다.

- zookeeper.properties

```docker

# the directory where the snapshot is stored.
dataDir=/root/kafka/zookeeper
# the port at which the clients will connect
clientPort=2181
# disable the per-ip limit on the number of connections since this is a non-production config
maxClientCnxns=0
tickTime=2000
initLimit=5
syncLimit=2
# Disable the adminserver by default to avoid port conflicts.
# Set the port to something non-conflicting if choosing to enable this
admin.enableServer=false
server.1=mykafka1:2888:3888
server.2=mykafka2:2888:3888
server.3=mykafka3:2888:3888
4lw.commands.whitelist=*

```

`clientPort`  주키퍼의 외부 연결 포트

`server.1=mykafka1:2888:3888`  [n번 주키퍼 서버의 호스트명 : 주키퍼가 내부적으로 사용하는 포트 1: 주키퍼가 내부적으로 사용하는 포트 2 ]  ← 각각의 서버에 대한 설정을 모두 기재하였습니다.

- kafka-init.sh

```bash
for i in 1 2 3; do
  host="mykafka$i"
  ssh -o StrictHostKeyChecking=no $host echo "\"broker.id=$i\" >> /root/kafka/config/server.properties"
  ssh $host mkdir -p /root/kafka/zookeeper
  ssh $host echo "\"$i\" > /root/kafka/zookeeper/myid"

  ssh $host "sh /root/kafka/bin/zookeeper-server-start.sh -daemon /root/kafka/config/zookeeper.properties"
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

```

(3번째 줄) - (카프카 추가설정) [`broker.id`](http://broker.id) 카프카 설정에 브로커 아이디를 각각 1,2,3을 추가합니다

(5번째 줄) - (주키퍼 추가설정)  주키퍼의 아이디가 담긴 myid 파일 생성합니다.

(이후) 각각의 호스트에서 주키퍼 실행 후 카프카 실행. 주키퍼 실행 후 20초 sleep을 해줌으로써 주키퍼가 완전히 실행한 뒤에 카프카가 실행되게끔 설정합니다.

(마지막 for문) 정상적으로 실행되었느지 확인하는 코드 생략 가능합니다.

## 도커 컴포즈 설정

```yaml
services:
  mykafka1:
    image: mykafka
    container_name: mykafka1
    networks:
      KafkaClusterPractice:
    volumes:
      - zookeeper_data_1:/root/kafka/zookeeper
      - kafka_data_1:/root/kafka/data
      - kafka_log_1:/root/kafka/logs
    command: [ "sh", "-c", "service ssh start; tail -f /dev/null" ]
  mykafka2:
    image: mykafka
    container_name: mykafka2
    networks:
      KafkaClusterPractice:
    volumes:
      - zookeeper_data_2:/root/kafka/zookeeper
      - kafka_data_2:/root/kafka/data
      - kafka_log_2:/root/kafka/logs
    command: [ "sh", "-c", "service ssh start; tail -f /dev/null" ]
  mykafka3:
    image: mykafka
    container_name: mykafka3
    networks:
      KafkaClusterPractice:
    volumes:
      - zookeeper_data_3:/root/kafka/zookeeper
      - kafka_data_3:/root/kafka/data
      - kafka_log_3:/root/kafka/logs
    command: [ "sh", "-c", "service ssh start; tail -f /dev/null" ]

volumes:
  zookeeper_data_1:
  kafka_data_1:
  kafka_log_1:
  zookeeper_data_2:
  kafka_data_2:
  kafka_log_2:
  zookeeper_data_3:
  kafka_data_3:
  kafka_log_3:

networks:
  KafkaClusterPractice:
```

volumes:
- zookeeper_data_1:/root/kafka/zookeeper
- kafka_data_1:/root/kafka/data
- kafka_log_1:/root/kafka/logs

볼륨을 각 컨테이너 마다 만들어주어 단순히 데이터를 모두 저장하게끔 해주었습니다. 컨테이들이 모두 종료되더라도 카프카 클러스터, 주키퍼 앙상블의 데이터를 저장하므로 재시작해도 토픽이 유지됩니다.

# 사용법

## 구성

1. 도커 이미지 빌드, 컨테이너 생성

```docker
# 윈도우
.\start-build.cmd 
# or 리눅스
sh start-build.sh
# 공통
docker compose up -d
```

1. 카프카 컨테이너로 이동

```docker
docker exec -it mykafka1 bash
```

1. 시작

```docker
## if 클러스터 첫 시작
sh kafka-init.sh
# or (클러스터 종료 후 재시작)
sh kafka-restart.sh
## END iF
```

1. 종료

```docker
# 외부 쉘에서
docker compose down
```

## 테스트

### 로그 확인

```docker
# (주키퍼 로그도 나온다)
cat $KAFKA_HOME/logs/server.log
```

- 주요 로그 내용 예시
  1. 주키퍼 연결

  *[2024-07-24 03:23:39,255]* INFO *[ZooKeeperClient Kafka server]* Connected. (kafka.zookeeper.ZooKeeperClient)

  1. 클러스터 아이디

  *[2024-07-24 03:23:39,531]* INFO Cluster ID = GdsyuwtoTOKCU0Hc5GLlSw (kafka.server.KafkaServer)

  1. 클러스터에 브로커 등록

  *[2024-07-24 03:23:40,026]* INFO Registered broker 1 at path /brokers/ids/1 with addresses: ArrayBuffer(EndPoint(448066a9cb04,9092,ListenerName(PLAINTEXT),PLAINTEXT)), czxid (broker epoch): 24 (kafka.zk.KafkaZkClient)


### 클러스터에 속한 브로커 아이디 조회

```docker
echo "ls /brokers/ids" | /root/kafka/bin/zookeeper-shell.sh mykafka1:2181
```

### 복제 계수를 3으로 토픽 생성

```docker
bin/kafka-topics.sh --create --topic any_topic_name \
--bootstrap-server mykafka1:9092, mykafka2:9092, mykafka3:9092 \
--partitions 3 \
--replication-factor 3
```

## 버전

우분투: `ubuntu22.04`

자바: `openjdk11`

카프카 : `kafka_2.12-2.5.0`