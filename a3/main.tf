# Provider declaraion
terraform {
  required_providers {
      aci = {
          source = "CiscoDevNet/aci"
      }
  }
}

# Provider configuration
provider "aci" {
    url = "https://nat.vprokopo.cisco.com:21291"
    username = "terraformuser"
    private_key = "terraformuser.key"
    cert_name = "terraformuser_cert"
}

# Tenant
resource "aci_tenant" "tenantLocalName" {
    name = "vanilla"
}

# VRF
resource "aci_vrf" "vrfLocalName" {
    name = "global_vrf"
    tenant_dn = aci_tenant.tenantLocalName.id
}

# Bridge Domain
resource "aci_bridge_domain" "bdLocalName" {
  name = "global_bd"
  tenant_dn = aci_tenant.tenantLocalName.id
  relation_fv_rs_ctx = aci_vrf.vrfLocalName.id
}

resource "aci_bridge_domain" "bdAppLocalName" {
  for_each = var.app_bd_map
  
  name = each.key
  tenant_dn = aci_tenant.tenantLocalName.id
  relation_fv_rs_ctx = aci_vrf.vrfLocalName.id
}

# Subnet
resource "aci_subnet" "subnetLocalName" {
    parent_dn = aci_bridge_domain.bdLocalName.id
    ip = "10.0.0.1/24"
    scope = [ "public" ]
}

resource "aci_subnet" "subnetAppLocalName" {
  for_each = var.app_bd_map
  
  parent_dn = aci_bridge_domain.bdAppLocalName[each.key].id
  ip = each.value.bd_subnet
  scope = [ "public" ]
}

# Application Profile
resource "aci_application_profile" "apLocalName" {
  tenant_dn = aci_tenant.tenantLocalName.id
  name = "3tier_ap"
}

# Web EPG
resource "aci_application_epg" "webEpgLocalName" {
  #for_each = toset([ "web1_epg", "web2_epg", "web3_epg" ])
  for_each = var.web_epg_set

  name = each.value
  application_profile_dn = aci_application_profile.apLocalName.id
  relation_fv_rs_bd = aci_bridge_domain.bdLocalName.id
  pref_gr_memb = "include"
}

# App EPG
resource "aci_application_epg" "appEpgLocalName" {
  for_each = var.app_epg_map

  name = each.key
  application_profile_dn = aci_application_profile.apLocalName.id
  relation_fv_rs_bd = aci_bridge_domain.bdAppLocalName[each.value.app_bd].id
  pref_gr_memb = "include"
}

# vzAny for VRF
resource "aci_any" "anyLocalName" {
    vrf_dn = aci_vrf.vrfLocalName.id
    pref_gr_memb = "enabled"
}