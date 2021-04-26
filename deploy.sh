# redis master ip
REDIS_MASTER_IP=127.0.0.1
# redis master port
REDIS_MASTER_PORT=6379

rm -rf ./conf/*.conf


cat > ./conf/master.conf <<EOF
port $REDIS_MASTER_PORT
dir "/data"
logfile "master-$REDIS_MASTER_PORT.log"
dbfilename "master-dump-$REDIS_MASTER_PORT.rdb"

requirepass "very_secret_password" 
masterauth "very_secret_password" 
EOF


SLAVE_PORT_LIST="6380 6381"

echo "Generate slave configuration file"
j=1
for SLAVE_PORT in $SLAVE_PORT_LIST
do
cat > ./conf/slave-$j.conf <<EOF
port $SLAVE_PORT
dir "/data"
logfile "slave-$SLAVE_PORT.log"
dbfilename "slave-dump-$SLAVE_PORT.rdb"
slaveof ${REDIS_MASTER_IP} ${REDIS_MASTER_PORT}
requirepass "very_secret_password" 
masterauth "very_secret_password" 
EOF
j=$(($j+1))
done


SENTINEL_PORT_LIST="26379 26380 26381"

echo "Generate sentinel configuration file"
i=1
for SENTINEL_PORT in $SENTINEL_PORT_LIST
do
cat > ./conf/sentinel-$i.conf <<EOF
port $SENTINEL_PORT
dir "/data"
logfile "sentinel-$SENTINEL_PORT.log"
sentinel monitor mymaster ${REDIS_MASTER_IP} ${REDIS_MASTER_PORT} 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 5000
sentinel parallel-syncs mymaster 1
sentinel auth-pass mymaster "very_secret_password"  
EOF
i=$(($i+1))
done


docker-compose up
