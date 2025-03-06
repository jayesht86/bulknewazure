resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  for_each = local.disk_attachments2

  managed_disk_id           = lookup(module.compute-managed_disk.managed_disk_list, each.value.disk, null).id
  virtual_machine_id        = one([for vm in azurerm_linux_virtual_machine.vm : vm.id if vm.name == each.value.vm])
  lun                       = each.value.lun
  caching                   = each.value.cache
  create_option             = each.value.create_option
  write_accelerator_enabled = each.value.write_accelerator

  depends_on = [azurerm_linux_virtual_machine.vm]
}
