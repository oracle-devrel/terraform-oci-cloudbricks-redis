#!/bin/bash
set -x

sudo tee /etc/redis.conf > /dev/null << EOF 
bind 127.0.0.1 ${redis_replica_ip}
port 6379
protected-mode no
dir /u01/data/lib/redis
loglevel notice
logfile /u01/data/log/redis/redis.log
replicaof ${redis_master_ip} 6379
masterauth ${redis_password}
pidfile /var/run/redis_6379.pid
EOF

sudo mkdir -p /u01/data/lib/redis
sudo mkdir -p /u01/data/log/redis

sudo chown -R redis:redis /u01 /usr/local/bin /etc/redis.conf
sudo chmod -R 755 /u01 /usr/local/bin /etc/redis.conf

sudo systemctl daemon-reload
sudo systemctl enable redis
sudo systemctl restart redis
sudo systemctl status redis
