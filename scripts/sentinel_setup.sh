#!/bin/bash

redis_master_ip=$1
redis_replica_count=$2

redis_replica_count=$((redis_replica_count-1))

sudo tee /usr/lib/systemd/system/redis-sentinel.service > /dev/null << EOF
[Unit]
Description=Redis Sentinel
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-sentinel /etc/redis/redis-sentinel.conf
ExecStop=/usr/local/bin/redis-cli -h 127.0.0.1 -p 26379 shutdown

Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/redis/redis-sentinel.conf > /dev/null << EOF 
port 26379
protected-mode no
dir /u01/data/lib/redis-sentinel
loglevel notice
logfile /u01/data/log/redis-sentinel/redis-sentinel.log
pidfile /var/run/redis-sentinel_26379.pid
sentinel monitor mymaster ${redis_master_ip} 6379 2
sentinel down-after-milliseconds mymaster 10000
sentinel failover-timeout mymaster 180000
sentinel parallel-syncs mymaster ${redis_replica_count}
EOF

sudo chown -R redis:redis /etc/redis/redis-sentinel.conf
sudo chmod -R 755 /etc/redis/redis-sentinel.conf

sudo systemctl daemon-reload
sudo systemctl enable redis-sentinel
sudo systemctl restart redis-sentinel
sudo systemctl status redis-sentinel
