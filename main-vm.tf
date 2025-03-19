resource "azurerm_linux_virtual_machine" "vm" {
  for_each = local.final_vm_list  # ✅ Uses merged existing + new VMs

  name                            = each.value.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = each.value.size
  admin_username                  = each.value.linux_vm_admin_username
  admin_password                  = each.value.linux_vm_admin_password
  zone                            = each.value.zone
  disable_password_authentication = coalesce(each.value.linux_vm_password_auth_disabled, var.linux_vm_password_auth_disabled)

  # ✅ Uses NIC IDs from `module.nic`
  network_interface_ids           = toset([for v in values(module.nic[each.key].nic_interface_list) : v.id])

  # ✅ Ensuring existing VMs keep their OS disk size
  os_disk {
    name                 = "${each.value.name}-osdisk"
    caching              = "ReadWrite"
    disk_size_gb         = coalesce(lookup(each.value, "os_disk_size_gb", var.os_disk_size_gb))
    storage_account_type = var.storage_account_type
  }

  # ✅ SSH Key Handling (Keeps old + supports new VMs)
  dynamic "admin_ssh_key" {
    for_each = coalesce(each.value.linux_vm_password_auth_disabled, var.vm_config.linux_vm_password_auth_disabled) ? flatten([
      for e in [
        each.value.linux_vm_public_keys,
        var.vm_config.linux_vm_public_keys
      ] : e if e != null
    ]) : []
    content {
      username   = admin_ssh_key.value.linux_vm_username
      public_key = admin_ssh_key.value.linux_vm_public_key
    }
  }

  source_image_reference {
    publisher = each.value.linux_vm_image_publisher
    offer     = each.value.linux_vm_image_offer
    sku       = each.value.linux_vm_image_sku
    version   = each.value.linux_vm_image_version
  }

  # Secure Boot & vTPM (Preserves existing VMs)
  secure_boot_enabled = var.linux_vm_os_disk_encryption_type != null ? true : coalesce(var.linux_vm_secure_boot_enabled, false)
  vtpm_enabled        = var.linux_vm_os_disk_encryption_type != null ? true : coalesce(var.linux_vm_vtpm_enabled, false)

  # ✅ Prevents unnecessary recreation of existing VMs
  encryption_at_host_enabled = coalesce(var.linux_vm_host_encryption_enabled, false)

  # ✅ Custom Data Support
  custom_data = try(var.linux_vm_custom_data, null)

  # Dedicated Hosts
  dedicated_host_id = try(var.linux_vm_dedicated_host_id, null)

  additional_capabilities {
    ultra_ssd_enabled = coalesce(var.linux_vm_ultra_disks_enabled, false)
  }

  boot_diagnostics {
    storage_account_uri = try(var.linux_vm_boot_diag_uri, null)
  }

  dynamic "identity" {
    for_each = var.linux_vm_identity_type != null ? [1] : []
    content {
      type         = var.linux_vm_identity_type
      identity_ids = var.linux_vm_identity_type == "UserAssigned" || var.linux_vm_identity_type == "SystemAssigned, UserAssigned" ? var.linux_vm_identity_ids : null
    }
  }

  # ✅ Tags - Merging Existing & New VM Tags
  tags = var.linux_vm_custom_tags != null ? merge(var.tags, var.linux_vm_custom_tags) : var.tags
}
