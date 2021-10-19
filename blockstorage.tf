# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# blockstorage.tf
#
# Purpose: The following script defines the declaration for block volumes using ISCSI Disks
# Registry: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_attachment
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_backup_policy_assignment

# Create Disk
resource "oci_core_volume" "ISCSIDisk_redis_master" {
  availability_domain = var.redis_master_ad
  compartment_id      = local.compartment_id
  display_name        = "${oci_core_instance.redis_master.display_name}_disk"
  size_in_gbs         = var.master_disk_size_in_gb
  vpus_per_gb         = var.master_disk_vpus_per_gb
}

# Create Disk Attachment
resource "oci_core_volume_attachment" "ISCSIDiskAttachment_redis_master" {
  depends_on      = [oci_core_volume.ISCSIDisk_redis_master]
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.redis_master.id
  volume_id       = oci_core_volume.ISCSIDisk_redis_master.id
}

# Assignment of backup policy for ProdDisk
resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment_ISCSI_Disk_redis_master" {
  asset_id  = oci_core_volume.ISCSIDisk_redis_master.id
  policy_id = local.master_backup_policy_id
}


# Create Disk
resource "oci_core_volume" "ISCSIDisk_redis_replica" {
  count               = var.redis_replica_count
  availability_domain = var.redis_replica_ad_list[count.index % length(var.redis_replica_ad_list)]
  compartment_id      = local.compartment_id
  display_name        = "${oci_core_instance.redis_replica[count.index].display_name}_disk"
  size_in_gbs         = var.replica_disk_size_in_gb
  vpus_per_gb         = var.replica_disk_vpus_per_gb
}

# Create Disk Attachment
resource "oci_core_volume_attachment" "ISCSIDiskAttachment_redis_replica" {
  count           = var.redis_replica_count
  depends_on      = [oci_core_volume.ISCSIDisk_redis_replica]
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.redis_replica[count.index].id
  volume_id       = oci_core_volume.ISCSIDisk_redis_replica[count.index].id
}

# Assignment of backup policy for ProdDisk
resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment_ISCSI_Disk_redis_replica" {
  count     = var.redis_replica_count
  asset_id  = oci_core_volume.ISCSIDisk_redis_replica[count.index].id
  policy_id = local.replica_backup_policy_id
}
