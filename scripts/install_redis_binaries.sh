#!/bin/bash

# Setup firewall rules
sudo -u root bash -c "firewall-cmd --permanent --zone=public --add-port=6379/tcp"
sudo -u root bash -c "firewall-cmd --permanent --zone=public --add-port=26379/tcp"
sudo -u root bash -c "firewall-cmd --reload"

# Install wget and gcc
sudo -u root bash -c "yum install -y wget gcc"

# Download and compile Redis
sudo mkdir redis-install
cd redis-install
sudo wget http://download.redis.io/releases/redis-${redis_version}.tar.gz
sudo tar xvzf redis-${redis_version}.tar.gz
cd redis-${redis_version}
sudo make install

sudo tee /usr/lib/systemd/system/redis.service > /dev/null << EOF
[Unit]
Description=Redis In-Memory Data Store
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown

Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Checks if the redis user already exists before attempting to create one
id -u redis &>/dev/null || sudo useradd redis
