# Redis Cluster with Sentinel by Docker Compose(1master+2slave+3sentinel)

There are following services in the cluster

* master: 1 Master Redis Server
* slave: 2 Slave Redis Server
* sentinel: 3 Sentinel Server

### Create configuration files and start services

```
$ sh deploy.sh
```

### Notice

```
If you get error to connect master user your machine ip instate of 127.0.0.1
```