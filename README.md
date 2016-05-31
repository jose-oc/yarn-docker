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
