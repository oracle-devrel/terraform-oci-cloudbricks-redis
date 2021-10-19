# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# output.tf 
#
# Purpose: The following file passes all outputs of the brick

output "redis_master_server" {
  description = "Redis Master Instance"
  sensitive   = true
  value = oci_core_instance.redis_master
}

output "redis_replica_servers" {
  description = "Redis Replica Instances"
  sensitive   = true
  value = oci_core_instance.redis_replica[*]
}