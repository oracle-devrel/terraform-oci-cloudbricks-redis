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

variable "base_compute_image_ocid" {
  description = "Defines the OCID for the OS image to be used on artifact creation. Extract OCID from: https://docs.cloud.oracle.com/iaas/images/ or designated custom image OCID created by packer"
}

variable "redis_master_name" {
  
}

variable "redis_master_shape" {
  
}

variable "redis_master_ad" {
  
}

variable "redis_master_fd" {
  
}

variable "redis_master_is_flex_shape" {
  type = bool
  default = false
}

variable "redis_master_ocpus" {
  default = ""
}

variable "redis_master_memory_in_gb" {
  default = ""
}

variable "redis_replica_name" {
  
}

variable "redis_replica_count" {
  
}

variable "redis_replica_shape" {
  
}

variable "redis_replica_ad_list" {
  
}

variable "redis_replica_fd_list" {
  
}

variable "redis_replica_is_flex_shape" {
  type = bool
  default = false
}

variable "redis_replica_ocpus" {
  default = ""
}

variable "redis_replica_memory_in_gb" {
  default = ""
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


/********** Brick Variables **********/