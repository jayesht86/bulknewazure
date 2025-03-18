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


association 
resource "azurerm_network_interface_application_security_group_association" "asg_association" {
  for_each = local.asg_attachment_map

  network_interface_id          = local.nic_list[each.value.nic_name] # ✅ Fetches NIC ID dynamically
  application_security_group_id = module.network-asg.asg_list[each.value.asg_name] # ✅ Uses ASG IDs from module output


data "azurerm_application_security_group" "existing_asgs" {
  for_each            = toset([for asg in var.asg_config : asg.asg_name])
  name                = each.value
  resource_group_name = var.resource_group_name
depends_on = [module.network-asg]
}


 asg_list = {
    for asg in data.azurerm_application_security_group.existing_asgs :
    asg.name => asg.id
  }
network_interface_id          = lookup(local.nic_list, each.value.nic_name, null) # ✅ Fetch NIC ID dynamically
  application_security_group_id = lookup(local.asg_list, each.value.asg_name, null) # ✅ Fetch ASG ID dynamically
}
}



