#!/usr/bin/env bash
echo Building Docker images...

sudo docker build -t myjava -f conf/java/Dockerfile-java conf/java
echo Built myjava image.

sudo docker build -t myssh -f conf/ssh/Dockerfile-ssh conf/ssh
echo Built myssh image.

sudo docker build -t mykafka -f conf/kafka/Dockerfile-kafka conf/kafka
echo Built kafka image.

echo All Docker images have been built successfully.