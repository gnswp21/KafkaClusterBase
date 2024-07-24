#!/usr/bin/env bash
echo Building Docker images...

sudo docker build -t myjava -f conf/java/Dockerfile-java conf/java
echo Built myjava image.

sudo docker build -t myssh -f conf/ssh/Dockerfile-ssh conf/ssh
echo Built myssh image.

sudo docker build -t myhadoop -f conf/hadoop/Dockerfile-hadoop conf/hadoop
echo Built myhadoop image.

sudo docker build -t myhahadoop -f conf/ha/Dockerfile-ha conf/ha
echo Built myhahadoop image.

sudo docker build -t namenode1 -f conf/namenodes/Dockerfile-namenode1 conf/namenodes
echo Built namenode1 image.

sudo docker build -t namenode2 -f conf/namenodes/Dockerfile-namenode2 conf/namenodes
echo Built namenode2 image.

sudo docker build -t resourcemanager -f conf/resourcemanager/Dockerfile-resourcemanager conf/resourcemanager
echo Built resourcemanager image.

sudo docker build -t datanode -f conf/datanode/Dockerfile-datanode conf/datanode
echo Built datanode image.

sudo docker build -t mykafka -f conf/kafka/Dockerfile-kafka conf/kafka
echo Built kafka image.

echo All Docker images have been built successfully.