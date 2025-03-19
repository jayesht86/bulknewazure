resource "azurerm_network_interface_application_security_group_association" "asg_association" {
  for_each = local.asg_attachment_map

  network_interface_id          = lookup(local.nic_list,each.value.nic_name, null) 
  #application_security_group_id = lookup(local.asg_list,each.value.asg_name, null ) 
  #network_interface_id          = lookup(local.nic_list[each.value.nic_name] )
  application_security_group_id = local.asg_list[each.value.asg_name] 
  depends_on = [ module.nic ]
}
