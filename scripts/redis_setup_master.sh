#!/bin/bash

sudo mkdir -p /etc/redis
sudo chown -R redis:redis /etc/redis
sudo chmod -R 770 /etc/redis

sudo tee /etc/redis/redis.conf > /dev/null << EOF 
bind 127.0.0.1 ${redis_master_ip}
port 6379
protected-mode no
dir /u01/data/lib/redis
loglevel notice
logfile /u01/data/log/redis/redis.log
pidfile /var/run/redis_6379.pid
min-replicas-to-write 2
min-replicas-max-lag 10
EOF

sudo mkdir -p /u01/data/lib/redis
sudo mkdir -p /u01/data/log/redis

sudo mkdir -p /u01/data/lib/redis-sentinel
sudo mkdir -p /u01/data/log/redis-sentinel

sudo chown -R redis:redis /u01 /usr/local/bin /etc/redis
sudo chmod -R 755 /u01 /usr/local/bin /etc/redis

sudo systemctl daemon-reload
sudo systemctl enable redis
sudo systemctl restart redis
sudo systemctl status redis

