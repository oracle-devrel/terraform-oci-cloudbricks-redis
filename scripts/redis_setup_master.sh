#!/bin/bash
set -x

sudo tee /etc/redis.conf > /dev/null << EOF 
bind 127.0.0.1 ${redis_master_ip}
port 6379
protected-mode no
dir /var/lib/redis
loglevel notice
logfile /var/log/redis/redis.log
requirepass ${redis_password}
pidfile /var/run/redis_6379.pid
EOF

sudo systemctl daemon-reload
sudo systemctl enable redis
sudo systemctl restart redis
sudo systemctl status redis

