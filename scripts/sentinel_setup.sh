


# Configure Sentinel
# cat << EOF > $SENTINEL_CONFIG_FILE
# port 26379

# sentinel monitor master ${redis_master_ip} 6379 2
# sentinel down-after-milliseconds master 10000
# sentinel failover-timeout master 180000
# sentinel parallel-syncs master 1
# EOF
