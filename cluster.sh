#!/bin/bash

# BUILD
# If you've performed changes in the docker image (the Dockerfile or any of the files which are copied into it) then build it with:
echo 
echo -e "\e[36mBuilding the docker image joseoc/yarn... \e[0m"
echo

docker build -t joseoc/yarn .

echo -e "\e[92mDone \e[0m"



# REMOVE containers
echo 
echo -e "\e[36mRemoving containers resolvable, master and slaves... \e[0m"
echo

N=${1:-2}
CUR_DIR="$PWD"

DOCKER_SOCKET_FILE_MAPPING="/var/run/docker.sock:/var/run/docker.sock"
DOCKER_LOCAL_TMP_MAPPING="/tmp/hadoop-root/nm-local-dir:/tmp/hadoop-root/nm-local-dir"
DOCKER_LOGS_MAPPING="/usr/local/hadoop/logs/userlogs:/usr/local/hadoop/logs/userlogs"

docker stop resolvable master
docker rm -f resolvable master

START=1
for (( c=$START; c<=$N; c++)) 
do
   docker rm -f slave$c
done

echo -e "\e[92mDone \e[0m"

# RUN containers
echo 
echo -e "\e[36mRunning containers... \e[0m"
echo
docker run -d --name resolvable --hostname resolvable -v /var/run/docker.sock:/tmp/docker.sock -v /etc/resolv.conf:/tmp/resolv.conf mgood/resolvable
docker run -d --name master -h master -e "SLAVES=$N" \
  -v $DOCKER_SOCKET_FILE_MAPPING \
  -v $DOCKER_LOCAL_TMP_MAPPING \
  -v $DOCKER_LOGS_MAPPING \
 joseoc/yarn

START=1
for (( c=$START; c<=$N; c++)) 
do
   docker run -d --link master:master --name slave$c -h slave$c \
  -v $DOCKER_SOCKET_FILE_MAPPING \
  -v $DOCKER_LOCAL_TMP_MAPPING \
  -v $DOCKER_LOGS_MAPPING \
   joseoc/yarn
done

echo -e "\e[92mDone \e[0m"

sleep 10


# EXECUTE hadoop in the cluster

echo 
echo -e "\e[36mStarting up HADOOP Cluster... \e[0m"
echo

docker exec -it master sh -c -l '/usr/local/hadoop/sbin/start-wrapper.sh'

echo
echo -e "\e[92mCluster started \e[0m"
echo -e "\e[92mHDFS UI on http://master:50070/dfshealth.html#tab-datanode \e[0m"
echo -e "\e[92mYARN UI on http://master:8088/cluster/nodes \e[0m"
echo
