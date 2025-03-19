# To retrive existing Resource Group
data "azurerm_resource_group" "existing_rg" {
  name = var.resource_group_name
}
# To retrive existing Vnet
data "azurerm_virtual_network" "existing_vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}
# To retrive existing subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}
data "azurerm_network_interface" "existing_nics" {
  for_each            = toset(local.nic_names)
  name                = each.value
  resource_group_name = var.resource_group_name
  depends_on = [ module.nic ]
}
data "azurerm_application_security_group" "existing_asgs" {
  for_each            = toset([for asg in var.asg_config : asg.asg_name])
  name                = each.value
  resource_group_name = var.resource_group_name
depends_on = [module.network-asg]
}
# terraform {
#   backend "azurerm" {
#     #tenant_id            = "7a9376d4-7c43-480f-82ba-a090647f651d" #MSCI OFFICE 365
#     subscription_id      = "59bab8f2-1319-472b-bb69-314d1b034ec0" #sandbox
#     resource_group_name  = "rgrp-dva2-ic-terratest"               #East US 2 RGRP
#     storage_account_name = "saccdva2icterratest003"
#     container_name       = "tfstate-compute-linux-vm-bulk"
#     key                  = "tfstate-compute-linux-vm-bulk.terraform.tfstate"
#     snapshot             = true
#   }
# }
