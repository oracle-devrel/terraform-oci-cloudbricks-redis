#!/bin/bash
set -x

export redis_master_ip="10.0.0.164"
export redis_replica_ip="10.0.0.147"
export redis_password="4tynu6ujr4t3nuujy24y344u"

sudo tee /etc/redis.conf > /dev/null << EOF 
bind 127.0.0.1 ${redis_replica_ip}
port 6379
protected-mode no
dir /var/lib/redis
loglevel notice
logfile /var/log/redis/redis.log
replicaof ${redis_master_ip} 6379
masterauth ${redis_password}
pidfile /var/run/redis_6379.pid
EOF

sudo systemctl daemon-reload
sudo systemctl enable redis
sudo systemctl restart redis
sudo systemctl status redis
