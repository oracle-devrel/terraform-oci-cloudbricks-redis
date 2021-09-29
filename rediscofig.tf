# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# mongoconfig.tf
#
# Purpose: The following script remotely executes all the setup scripts on the Redis compute instances

data "template_file" "install_redis_binaries_sh" {
  template = file("scripts/install_redis_binaries.sh")

  vars = {
    redis_version = var.redis_version
  }
}

data "template_file" "redis_setup_master_sh" {
  depends_on = [oci_core_instance.redis_master]
  template = file("scripts/redis_setup_master.sh")

  vars = {
    redis_master_ip = oci_core_instance.redis_master.private_ip
    redis_password = var.redis_password
  }
}

data "template_file" "redis_setup_replica_sh" {
  depends_on = [oci_core_instance.redis_replica]
  count = var.redis_replica_count
  template = file("scripts/redis_setup_replica.sh")

  vars = {
    redis_master_ip = oci_core_instance.redis_replica[count.index].private_ip
    redis_password = var.redis_password
  }
}
