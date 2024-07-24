@echo off
echo Building Docker images...

docker build -t myjava -f conf/java/Dockerfile-java conf/java
echo Built myjava image.

docker build -t myssh -f conf/ssh/Dockerfile-ssh conf/ssh
echo Built myssh image.

docker build -t myhadoop -f conf/hadoop/Dockerfile-hadoop conf/hadoop
echo Built myhadoop image.

docker build -t myhahadoop -f conf/ha/Dockerfile-ha conf/ha
echo Built myhahadoop image.

docker build -t namenode1 -f conf/namenodes/Dockerfile-namenode1 conf/namenodes
echo Built namenode1 image.

docker build -t namenode2 -f conf/namenodes/Dockerfile-namenode2 conf/namenodes
echo Built namenode2 image.

docker build -t resourcemanager -f conf/resourcemanager/Dockerfile-resourcemanager conf/resourcemanager
echo Built resourcemanager image.

docker build -t datanode -f conf/datanode/Dockerfile-datanode conf/datanode
echo Built datanode image.

docker build -t mykafka -f conf/kafka/Dockerfile-kafka conf/kafka
echo Built kafka image.

echo All Docker images have been built successfully.