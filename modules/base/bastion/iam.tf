# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# create a home region provider for identity operations
provider "oci" {
  alias            = "home"
  fingerprint      = var.oci_base_identity.api_fingerprint
  private_key_path = var.oci_base_identity.api_private_key_path
  region           = var.oci_bastion_general.home_region
  tenancy_ocid     = var.oci_base_identity.tenancy_id
  user_ocid        = var.oci_base_identity.user_id
}

data "oci_identity_compartments" "compartments_name" {
  access_level              = "ACCESSIBLE"
  compartment_id            = var.oci_base_identity.tenancy_id
  compartment_id_in_subtree = "true"

  filter {
    name   = "name"
    values = [var.oci_base_identity.compartment_name]
  }
}

resource "oci_identity_dynamic_group" "bastion_instance_principal" {
  provider       = "oci.home"
  compartment_id = var.oci_base_identity.tenancy_id
  description    = "dynamic group to allow instances to call services for 1 bastion"
  matching_rule  = "ALL {instance.id = '${join(",", data.oci_core_instance.bastion.*.id)}'}"
  name           = "${var.oci_bastion_general.label_prefix}-bastion_instance_principal"
  count          = var.oci_bastion.enable_instance_principal == true ? 1 : 0
}

resource "oci_identity_policy" "bastion_instance_principal" {
  provider       = "oci.home"
  compartment_id = var.oci_base_identity.compartment_id
  description    = "policy to allow bastion host to call services"
  name           = "${var.oci_bastion_general.label_prefix}-bastion_instance_principal"
  statements     = ["Allow dynamic-group ${oci_identity_dynamic_group.bastion_instance_principal[0].name} to manage all-resources in compartment ${data.oci_identity_compartments.compartments_name.compartments.0.name}"]
  count          = var.oci_bastion.enable_instance_principal == true ? 1 : 0
}
