resource "azurerm_managed_disk" "disk" {
  for_each = { for disk in var.disks : disk.name => disk }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_type = "Standard_LRS"
  disk_size_gb         = each.value.size
  create_option        = "Empty"
  zone                 = var.zone
/*   disks = [
     { name = "${each.value.name}-data-disk-${each.key}", size = 64 },

   ] */
  tags = {
    environment = "Dev"
  }
}
