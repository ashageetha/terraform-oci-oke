# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# Identity and access parameters

variable "compartment_id" {}

# general oci parameters

variable "oke_general" {
  type = object({
    ad_names     = list(string)
    label_prefix = string
    region       = string
  })
}

# networking parameters

variable "oke_network_vcn" {
  type = object({
    ig_route_id                = string
    is_service_gateway_enabled = bool
    nat_route_id               = string
    newbits                    = map(number)
    subnets                    = map(number)
    vcn_cidr                   = string
    vcn_id                     = string
  })
}

# oke node

variable "oke_network_worker" {
  type = object({
    allow_node_port_access  = bool
    allow_worker_ssh_access = bool
    worker_mode             = string
  })
}

# load balancers

variable "lb_subnet_type" {}
