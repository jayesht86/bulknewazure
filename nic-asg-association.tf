resource "azurerm_network_interface_application_security_group_association" "asg_association" {
  for_each = local.asg_attachment2

  network_interface_id          = module.compute-linux_vm.linux_vm_list[regex(".*-(.*)",each.value.nic)[0]].nic[each.value.nic].id
  application_security_group_id = module.network-asg.asg_list[each.value.asg].id
}
