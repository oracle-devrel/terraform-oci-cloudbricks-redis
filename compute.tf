# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# blockstorage.tf
#
# Purpose: The following script defines the declaration of computes needed for the PostgreSQL deployment
# Registry: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_backup_policy_assignment


resource "oci_core_instance" "redis_master" {
  availability_domain = var.redis_master_ad
  compartment_id      = local.compartment_id
  display_name        = var.redis_master_name
  shape               = var.redis_master_shape

  dynamic "shape_config" {
    for_each = var.redis_master_is_flex_shape ? [1] : []
    content {
      ocpus         = var.redis_master_ocpus
      memory_in_gbs = var.redis_master_memory_in_gb
    }
  }

  fault_domain = var.redis_master_fd

  create_vnic_details {
    subnet_id        = local.private_subnet_ocid
    display_name     = "primaryvnic"
    assign_public_ip = false
    hostname_label   = var.redis_master_name
    nsg_ids          = local.nsg_id == "" ? [] : [local.nsg_id]
  }

  source_details {
    source_type = "image"
    source_id   = var.base_compute_image_ocid
  }

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "opc"
    private_key = file(var.ssh_private_key)
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}

resource "oci_core_instance" "redis_replica" {
  count               = var.redis_replica_count
  availability_domain = var.redis_replica_ad_list[count.index % length(var.redis_replica_ad_list)]
  compartment_id      = local.compartment_id
  display_name        = "${var.redis_replica_name}${count.index + 1}"
  shape               = var.redis_replica_shape

  dynamic "shape_config" {
    for_each = var.redis_replica_is_flex_shape ? [1] : []
    content {
      ocpus         = var.redis_replica_ocpus
      memory_in_gbs = var.redis_replica_memory_in_gb
    }
  }

  fault_domain = var.redis_replica_fd_list[floor(count.index / length(var.redis_replica_fd_list))]

  create_vnic_details {
    subnet_id        = local.private_subnet_ocid
    display_name     = "primaryvnic"
    assign_public_ip = false
    hostname_label   = "${var.redis_replica_name}${count.index + 1}"
    nsg_ids          = local.nsg_id == "" ? [] : [local.nsg_id]
  }

  source_details {
    source_type = "image"
    source_id   = var.base_compute_image_ocid
  }

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "opc"
    private_key = file(var.ssh_private_key)
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}
