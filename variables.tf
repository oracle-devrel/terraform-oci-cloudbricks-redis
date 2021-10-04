# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# variables.tf 
#
# Purpose: The following file declares all variables used in this backend repository

/********** Provider Variables NOT OVERLOADABLE **********/
variable "region" {
  description = "Target region where artifacts are going to be created"
}

variable "tenancy_ocid" {
  description = "OCID of tenancy"
}

variable "user_ocid" {
  description = "User OCID in tenancy. Currently hardcoded to user denny.alquinta@oracle.com"
}

variable "fingerprint" {
  description = "API Key Fingerprint for user_ocid derived from public API Key imported in OCI User config"
}

variable "private_key_path" {
  description = "Private Key Absolute path location where terraform is executed"
}

/********** Provider Variables NOT OVERLOADABLE **********/

/********** Brick Variables **********/

variable "redis_master_name" {
  description = "The name given to the master instance"
}

variable "redis_master_shape" {
  description = "The shape for the master instance to use"
}

variable "redis_master_ad" {
  description = "The availability domain to provision the master instance in"
}

variable "redis_master_fd" {
  description = "The fault domain to provision the master instance in"
}

variable "redis_master_is_flex_shape" {
  description = "Boolean to determine if the master instance is flex or not"
  type        = bool
  default     = false
}

variable "redis_master_ocpus" {
  description = "The number of OCPUS for the master instance to use when flex shape is enabled"
  default     = ""
}

variable "redis_master_memory_in_gb" {
  description = "The amount of memory in GB for the master instance to use when flex shape is enabled"
  default     = ""
}

variable "redis_replica_name" {
  description = "The name given to the replica instances"
}

variable "redis_replica_count" {
  description = "The number of replica instances to provision"
  type        = number
}

variable "redis_replica_shape" {
  description = "The shape for the replica instances to use"
}

variable "redis_replica_ad_list" {
  description = "The availability domains to provision the replica instances in"
}

variable "redis_replica_fd_list" {
  description = "The fault domains to provision the replica instances in"
}

variable "redis_replica_is_flex_shape" {
  description = "Boolean to determine if the replica instances are flex or not"
  type        = bool
  default     = false
}

variable "redis_replica_ocpus" {
  description = "The number of OCPUS for the replica instances to use when flex shape is enabled"
  default     = ""
}

variable "redis_replica_memory_in_gb" {
  description = "The amount of memory in GB for the replica instances to use when flex shape is enabled"
  default     = ""
}

variable "ssh_public_key" {
  description = "Defines SSH Public Key to be used in order to remotely connect to compute instances"
}

variable "ssh_private_key" {
  description = "Defines SSH Private Key to be used in order to remotely connect to compute instances"
}

variable "linux_compute_instance_compartment_name" {
  description = "Defines the compartment name where the infrastructure will be created"
}

variable "linux_compute_network_compartment_name" {
  description = "Defines the compartment where the Network is currently located"
}

variable "vcn_display_name" {
  description = "VCN Display name to execute lookup"
}

variable "private_network_subnet_name" {
  description = "Defines the subnet display name where this resource will be created at"
}

variable "compute_nsg_name" {
  description = "Name of the NSG associated to the computes"
  default     = ""
}

variable "instance_backup_policy_level" {
  description = "The backup policy of all instances boot volumes"
}

variable "master_disk_size_in_gb" {
  description = "The size of the attached disk to the master instance, stores database and log data"
}

variable "master_disk_vpus_per_gb" {
  description = "The VPUS of the attached disk to the master instance"
}

variable "master_backup_policy_level" {
  description = "The backup policy of the master instance ISCSI disk"
}

variable "replica_disk_size_in_gb" {
  description = "The size of the attached disk to the replica instances, stores database and log data"
}

variable "replica_disk_vpus_per_gb" {
  description = "The VPUS of the attached disk to the replica instances"
}

variable "replica_backup_policy_level" {
  description = "The backup policy of replica instances ISCSI disks"
}

variable "redis_version" {
  description = "The version of Redis used in the setup"
}

/********** Brick Variables **********/
