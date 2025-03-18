data "azurerm_resource_group" "existing_rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "existing_vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

data "azurerm_subnet" "existing_subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}
data "azurerm_network_interface" "existing_nics" {
  for_each            = toset(local.nic_names)
  name                = each.value
  resource_group_name = var.resource_group_name
}
locals {
  nic_names = flatten([
    for vm in local.vm_list : concat(
      [vm.linux_vm_default_nic.nic_name],
      [for nic in vm.linux_vm_additional_nic : nic.nic_name]
    )
  ])

  # Extract NIC IDs from data source
  nic_list = { for name, nic in data.azurerm_network_interface.existing_nics : name => nic.id }
}

