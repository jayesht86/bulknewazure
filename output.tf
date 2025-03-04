/* output "vm_names" {
  #value = [for vm in module.vm : vm.name]
  value = {for k, v in module.vm : k => v.vm_name }
}
output "nic_names" {
  #value = [for vm in module.vm : vm.name]
  value = {for k, v in module.nic : k => v.nic_names }
} */
/* output "disk_names" {
  #value = [for vm in module.vm : vm.name]
  value = {for k, v in module.disk : k => v.disk_names }
} */
output "vm_name" {
  #value = [for vm in module.vm : vm.name]
  value = var.name
}
output "disk_ids" {
  #value = [for d in azurerm_managed_disk.disk : d.id]
  value = { for disk_key, disk in azurerm_managed_disk.disk : disk_key => disk.id }
}
output "disk_names" {
  #value = [for d in azurerm_managed_disk.disk : d.id]
  value = { for k, disk in azurerm_managed_disk.disk : k => disk.name }
}
output "nic_ids" {
  value = { for key, nic in azurerm_network_interface.nic : key => nic.id }  #azurerm_network_interface.nic.id
}
/* output "nic_names" {
  value = { for k, nic in azurerm_network_interface.nic : k => nic.name}  #azurerm_network_interface.nic.id
} */
