# Provider declaraion
terraform {
  required_providers {
      aci = {
          source = "CiscoDevNet/aci"
      }
  }
}

# L3out
resource "aci_l3_outside" "l3outLocalName" {
    name = var.l3out_name
    tenant_dn = var.tenant_dn
    relation_l3ext_rs_ectx = var.vrf_dn
}

# External EPG
resource "aci_external_network_instance_profile" "exEpgLocalName" {
    l3_outside_dn = aci_l3_outside.l3outLocalName.id
    name = "global_brf_exepg"
    pref_gr_memb = "include"
}

# Subnet A
resource "aci_l3_ext_subnet" "subnetAlocalName" {
    external_network_instance_profile_dn = aci_external_network_instance_profile.exEpgLocalName.id
    ip = "0.0.0.0/1"
}

# Subnet B
resource "aci_l3_ext_subnet" "subnetBlocalName" {
    external_network_instance_profile_dn = aci_external_network_instance_profile.exEpgLocalName.id
    ip = "128.0.0.0/1"
}

# Node Profile
resource "aci_logical_node_profile" "nodeProfilelocalName" {
    l3_outside_dn = aci_l3_outside.l3outLocalName.id
    name = "global_vrf_l3out_nodeProfile"
}

# Node 111
resource "aci_logical_node_to_fabric_node" "nodeLocalName" {
    logical_node_profile_dn = aci_logical_node_profile.nodeProfilelocalName.id
    tdn = "topology/pod-1/node-111"
    rtr_id = "1.1.1.1"
    rtr_id_loop_back = "no"
}

# Interface Profile
resource "aci_logical_interface_profile" "intPlocalName" {
    logical_node_profile_dn = aci_logical_node_profile.nodeProfilelocalName.id
    name = "global_vrf_l3out_interfaceProfile"
}

# Outputs
output "l3out_dn" {
  value = aci_l3_outside.l3outLocalName.id
}