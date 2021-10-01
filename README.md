# OCI Cloud Bricks: Redis

[![License: UPL](https://img.shields.io/badge/license-UPL-green)](https://img.shields.io/badge/license-UPL-green) [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=oracle-devrel_terraform-oci-cloudbricks-redis)](https://sonarcloud.io/dashboard?id=oracle-devrel_terraform-oci-cloudbricks-redis)

## Introduction
The following brick contains the logic to provision a Redis database caluster in a highly available architecture. This is compromised of a master server and any number of replicas.

## Reference Architecture
The following is the reference architecture associated to this brick

![Reference Architecture](./images/Bricks_Architectures-redis.jpg)

### Prerequisites
- Pre-baked Artifact and Network Compartments
- Pre-baked VCN

# Sample tfvar file

If using Fixes Shapes.

```shell
######################################## COMMON VARIABLES ######################################
region           = "re-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
user_ocid        = "ocid1.user.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
######################################## COMMON VARIABLES ######################################
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
ssh_public_key                          = "/absolute/path/to/api/key/your_ssh_public_key.pub"
ssh_private_key                         = "/absolute/path/to/api/key/your_ssh_private_key"
compute_nsg_name                        = "MY_NSG"
linux_compute_instance_compartment_name = "MY_ARTIFACT_COMPARTMENT"
linux_compute_network_compartment_name  = "MY_NETWORK_COMPARTMENT"
private_network_subnet_name             = "MY_PRIVATE_SUBNET"
vcn_display_name                        = "MY_VCN"

base_compute_image_ocid = "ocid1.image.oc1.uk-london-1.aaaaaaaabcedfghijklmonoprstuvwxyz" 

redis_master_name  = "MY_REDIS_MASTER_NAME"
redis_master_shape = "VM.Standard2.1"
redis_master_ad    = "aBCD:RE-REGION-1-AD-1"
redis_master_fd    = "FAULT-DOMAIN-1"

redis_replica_name    = "MY_REDIS_REPLICA_NAME"
redis_replica_count   = "3"
redis_replica_shape   = "VM.Standard2.1"
redis_replica_ad_list = ["oDQF:UK-LONDON-1-AD-1", "oDQF:UK-LONDON-1-AD-2", "oDQF:UK-LONDON-1-AD-3"]
redis_replica_fd_list = ["FAULT-DOMAIN-1", "FAULT-DOMAIN-2", "FAULT-DOMAIN-3"]

redis_version  = "6.2.5"

instance_backup_policy_level = "bronze"

master_disk_size_in_gb     = "50"
master_disk_vpus_per_gb    = "10"
master_backup_policy_level = "bronze"

replica_disk_size_in_gb     = "50"
replica_disk_vpus_per_gb    = "10"
replica_backup_policy_level = "bronze"
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
```

If using Flex Shapes.

```shell
######################################## COMMON VARIABLES ######################################
region           = "re-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
user_ocid        = "ocid1.user.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
######################################## COMMON VARIABLES ######################################
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
ssh_public_key                          = "/absolute/path/to/api/key/your_ssh_public_key.pub"
ssh_private_key                         = "/absolute/path/to/api/key/your_ssh_private_key"
compute_nsg_name                        = "MY_NSG"
linux_compute_instance_compartment_name = "MY_ARTIFACT_COMPARTMENT"
linux_compute_network_compartment_name  = "MY_NETWORK_COMPARTMENT"
private_network_subnet_name             = "MY_PRIVATE_SUBNET"
vcn_display_name                        = "MY_VCN"

base_compute_image_ocid = "ocid1.image.oc1.uk-london-1.aaaaaaaabcedfghijklmonoprstuvwxyz" 

redis_master_name          = "MY_REDIS_MASTER_NAME"
redis_master_shape         = "VM.Standard.E4.Flex"
redis_master_ad            = "aBCD:RE-REGION-1-AD-1"
redis_master_fd            = "FAULT-DOMAIN-1"
redis_master_is_flex_shape = true
redis_master_ocpus         = "1"
redis_master_memory_in_gb  = "16"

redis_replica_name          = "MY_REDIS_REPLICA_NAME"
redis_replica_count         = "3"
redis_replica_shape         = "VM.Standard.E4.Flex"
redis_replica_ad_list       = ["oDQF:UK-LONDON-1-AD-1", "oDQF:UK-LONDON-1-AD-2", "oDQF:UK-LONDON-1-AD-3"]
redis_replica_fd_list       = ["FAULT-DOMAIN-1", "FAULT-DOMAIN-2", "FAULT-DOMAIN-3"]
redis_replica_is_flex_shape = true
redis_replica_memory_in_gb  = "1"
redis_replica_ocpus         = "16"

redis_version  = "6.2.5"

instance_backup_policy_level = "bronze"

master_disk_size_in_gb     = "50"
master_disk_vpus_per_gb    = "10"
master_backup_policy_level = "bronze"

replica_disk_size_in_gb     = "50"
replica_disk_vpus_per_gb    = "10"
replica_backup_policy_level = "bronze"
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
```

### Variable Specific Conisderions
- Compute ssh keys to later log into instances. Paths to the keys should be provided in variables `ssh_public_key` and `ssh_private_key`.
- Variable `compute_nsg_name` is an optional network security group that can be attached.
- Variable `redis_version` may be set to any of the supported version of Redis at the time of creating this brick `(6.2.5, 6.0.15, 5.0.13)` Source: [Redis endoflife](https://endoflife.date/redis)
- Variable `base_compute_image_ocid` should be the latest OCID of Oracle Autonomous Linux for your region, found at [Oracle Cloud Infrastructure Documentation / Images](https://docs.cloud.oracle.com/iaas/images/)
- Variable `redis_replica_count` determines how many replica instance are provisioned. This value has been tested between `1-30`, however a minimum of `3` is recommended.
- Variable `instance_backup_policy_level` specifies the name of the backup policy used on the instance boot volumes.
- Variables `master_backup_policy_level` and `replica_backup_policy_level` specificy the name of the backup policy used on the ISCSI disks storing data and log files on the master and replica servers respectively.
- Variables `master_disk_size_in_gb` and `replica_disk_size_in_gb` specify the size of the ISCSI disks in GB used to store data and log files on the master and replica servers respectively. This can be between `50` and `32768`.
- Variable `master_disk_vpus_per_gb` and `replica_disk_vpus_per_gb` specify the VPUs per GB of the ISCSI disks used to store data and log files on the master and replica servers respectively. The value must be between `0` and `120` and be multiple of 10.
- Flex Shapes:
  - Variable `redis_master_is_flex_shape` should be defined as true when the master instance is a flex shape. The variables `redis_master_ocpus` and `redis_master_memory_in_gb` should then also be defined. Do not use any of these variables at all when using a standard shape as they are not needed and assume sensible defaults.
  - Variable `redis_replica_is_flex_shape` should be defined as true when the replica instances are a flex shape. The variables `redis_replica_ocpus` and `redis_replica_memory_in_gb` should then also be defined. Do not use any of these variables at all when using a standard shape as they are not needed and assume sensible defaults.

### Sample provider
The following is the base provider definition to be used with this module

```shell
terraform {
  required_version = ">= 0.13.5"
}
provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  disable_auto_retries = "true"
}

provider "oci" {
  alias        = "home"
  region       = data.oci_identity_region_subscriptions.home_region_subscriptions.region_subscriptions[0].region_name
  tenancy_ocid = var.tenancy_ocid  
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  disable_auto_retries = "true"
}
```
## Variable documentation




## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2021 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.
