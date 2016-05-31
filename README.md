Hadoop Yarn dockerized
====

This is a set of scripts to create a full Hadoop Yarn cluster, each node inside a docker container.

Quick start
---

If you don't have the github repo cloned, run this command to create a 3 node YARN cluster:

```
bash <(curl -s https://raw.githubusercontent.com/jose-oc/yarn-docker/master/cluster.sh)
```


Usage
---
The step above is the same as running the script `cluster.sh`. You can specify the number of slaves: 

```
./cluster.sh 3
```

After the container creation the script will print the master ip address.

* http://master:50070 for the HDFS console
* http://master:8088 for the YARN UI


Details
---

Each container is based on Alpine Linux and OpenJDK 1.8. 
The _master_ container will run the *namenode*, *secondary namenode*, and the *resource manager*. 
Each _slave_ container will run the *data node* and the *node manager*. 

If you wanted to get into these container just run `docker exec -ti master bash` (in case of getting into master).



## Check hadoop is running

Check the processes in master:

```
# Get into master
docker exec -ti master bash
# Check processes
jps
# Should respond
# ResourceManager
# NameNode
# SecondaryNameNode
```

Check the processes in the slaves:

```
# Get into slave
docker exec -ti slave1 bash
# Check processes
jps
# Should respond
# NodeManager
# DataNode
```

## Stop hadoop

Get into the master container and run:
```
/usr/local/hadoop/sbin/stop-yarn.sh && \
/usr/local/hadoop/sbin/stop-dfs.sh
```

## Start hadoop 

Get into the master container and run:
```
/usr/local/hadoop/sbin/start-dfs.sh && \
/usr/local/hadoop/sbin/start-yarn.sh
```

The first time we start hadoop we have to use this script: 
```
/usr/local/hadoop/sbin/start-wrapper.sh
```
Since it modifies the configuration files to set the correct IPs.

# Use the LinuxContainerExecutor

*ISSUE:* the NodeManager does NOT startup with this configuration. Something is wrong.

## Check it is using LinuxContainerExecutor

### Master

In the webpage `http://master:8088/conf` we can find all the configuration params form master. Look for the param `yarn.nodemanager.container-executor.class` which should have the value `org.apache.hadoop.yarn.server.nodemanager.LinuxContainerExecutor`.

### Slaves

In the webpage `http://slave1:8042/conf` we can find all the configuration params form master. Look for the param `yarn.nodemanager.container-executor.class` which should have the value `org.apache.hadoop.yarn.server.nodemanager.LinuxContainerExecutor`.

# MapReduce example

```
$HADOOP_PREFIX/bin/hadoop jar $HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.2.jar pi 4 10000
```