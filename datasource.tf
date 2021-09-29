# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# datasource.tf
#
# Purpose: The following script defines the lookup logic used in code to obtain pre-created or JIT-created resources in tenancy.

/********** Compartment Accessors **********/
data "oci_identity_compartments" "COMPARTMENTS" {
  compartment_id            = var.tenancy_ocid
  compartment_id_in_subtree = true
  filter {
    name   = "name"
    values = [var.linux_compute_instance_compartment_name]
  }
}

data "oci_identity_compartments" "NWCOMPARTMENTS" {
  compartment_id            = var.tenancy_ocid
  compartment_id_in_subtree = true
  filter {
    name   = "name"
    values = [var.linux_compute_network_compartment_name]
  }
}

/********** Virual Cloud Network Accessor **********/
data "oci_core_vcns" "VCN" {
  compartment_id = local.nw_compartment_id
  filter {
    name   = "display_name"
    values = [var.vcn_display_name]
  }
}

/********** Subnet Accessor **********/
data "oci_core_subnets" "PRIVATESUBNET" {
  compartment_id = local.nw_compartment_id
  vcn_id         = local.vcn_id
  filter {
    name   = "display_name"
    values = [var.private_network_subnet_name]
  }
}

/********** Network Security Group Accessor **********/
data "oci_core_network_security_groups" "NSG" {
  compartment_id = local.nw_compartment_id
  vcn_id         = local.vcn_id

  filter {
    name   = "display_name"
    values = ["${var.compute_nsg_name}"]
  }
}


locals {

  # Subnet OCID local accessors
  private_subnet_ocid = length(data.oci_core_subnets.PRIVATESUBNET.subnets) > 0 ? data.oci_core_subnets.PRIVATESUBNET.subnets[0].id : null

  # Compartment OCID Local Accessor
  compartment_id    = lookup(data.oci_identity_compartments.COMPARTMENTS.compartments[0], "id")
  nw_compartment_id = lookup(data.oci_identity_compartments.NWCOMPARTMENTS.compartments[0], "id")

  # VCN OCID Local Accessor
  vcn_id = lookup(data.oci_core_vcns.VCN.virtual_networks[0], "id")

  # NSG OCID Local Accessor
  nsg_id = length(data.oci_core_network_security_groups.NSG.network_security_groups) > 0 ? lookup(data.oci_core_network_security_groups.NSG.network_security_groups[0], "id") : ""

}
