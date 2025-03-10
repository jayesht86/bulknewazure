resource "azurerm_linux_virtual_machine" "vm" {
  for_each = { for obj in local.vm_list : obj.name => obj }
   
  name                  = each.value.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = each.value.size
  admin_username        = each.value.admin_username
  admin_password        = each.value.admin_password
  zone                  = var.zones[0]
  disable_password_authentication = false #var.password_auth_disabled
  network_interface_ids = toset([for v in values(module.nic[each.key].nic_interface_list) : v.id ])

  # OS Disk Configuration
  os_disk {
    name                 = "${var.name}-osdisk"
    caching              = "ReadWrite" #var.linux_vm_os_disk_cache
    #create_option        = "FromImage"
    disk_size_gb         = var.os_disk_size_gb
    storage_account_type = "Standard_LRS" #var.linux_vm_os_disk_type
  }

    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  # Secure Boot & vTPM
  secure_boot_enabled = var.linux_vm_os_disk_encryption_type != null ? true : coalesce(var.linux_vm_secure_boot_enabled, false)
  vtpm_enabled        = var.linux_vm_os_disk_encryption_type != null ? true : coalesce(var.linux_vm_vtpm_enabled, false)

  # Encryption at Host
  encryption_at_host_enabled = coalesce(var.linux_vm_host_encryption_enabled, false)

  # Custom Data
  custom_data = try(var.linux_vm_custom_data, null)

  # Dedicated Hosts
  dedicated_host_id = try(var.linux_vm_dedicated_host_id, null)

  # Additional Capabilities
  additional_capabilities {
    ultra_ssd_enabled = coalesce(var.linux_vm_ultra_disks_enabled, false)
  }

  # Boot Diagnostics
  boot_diagnostics {
    storage_account_uri = try(var.linux_vm_boot_diag_uri, null)
  }

  # Identity Block (Dynamically Created if Identity Type Exists)
  dynamic "identity" {
    for_each = var.linux_vm_identity_type != null ? [1] : []
    content {
      type         = var.linux_vm_identity_type
      identity_ids = var.linux_vm_identity_type == "UserAssigned" || var.linux_vm_identity_type == "SystemAssigned, UserAssigned" ? var.linux_vm_identity_ids : null
    }
  }

  # Tags - Merge Default & Custom Tags
  tags = var.linux_vm_custom_tags != null ? merge(var.tags, var.linux_vm_custom_tags) : var.tags
}
