
resource "azurerm_network_interface" "nic" {
  for_each = { for nic in var.network_interfaces : nic.name => nic  if length(var.network_interfaces) > 0}
  name                = "${var.vm_name}-${each.value.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  accelerated_networking_enabled = coalesce(each.value.accelerated_networking_enabled, false)
  dynamic "ip_configuration" {
    for_each = each.value.nic_ip_config
    content {
      
      name = ip_configuration.value.name
      subnet_id = var.subnet_id
      private_ip_address_allocation = lookup(ip_configuration.value, "private_ip_address_allocation", "Dynamic") 


    }
  }
}
