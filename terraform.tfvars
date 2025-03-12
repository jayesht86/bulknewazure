# Resource Group and Location
resource_group_name = "demorg1"
location            = "East US"


# VNet and Subnet Details
vnet_name   = "demovnet1"
subnet_name = "demosubnet1"

# VM Configuration - List of VM Details
# VM Configuration (Using a Single Object with Zone List)
vm_config = {
  size                                                         = "Standard_D2s_v3"
  zone_list                                                    = ["3", "2"]
  linux_vm_admin_username                                      = "adminuser"
  linux_vm_admin_password                                      = "Password123!"
  os_disk_size_gb                                              = 64
  linux_vm_extension_monitoring_enabled                        = true
  vm_extension_failure_suppression_enabled                     = true
  linux_vm_extension_custom_script_enabled                     = true
  linux_vm_extension_custom_script_failure_suppression_enabled = true
  linux_vm_extension_encryption_enabled                        = true
  linux_vm_extension_encryption_failure_suppression_enabled    = true
  linux_vm_extension_ado_agent_enabled                         = true
  linux_vm_extension_ado_agent_failure_suppression_enabled     = true
  linux_vm_extension_aad_ssh_enabled                           = true
  linux_vm_extension_aadssh_failure_suppression_enabled        = true
  linux_vm_extension_monitoring_failure_suppression_enabled    = true
  linux_vm_extension_encryption_key_vault_kek_version          = "abcd"
  linux_vm_extension_encryption_key_vault_kek_name             = "temp"
  linux_vm_image_publisher                                     = "Canonical"
  linux_vm_image_offer                                         = "0001-com-ubuntu-server-focal"
  linux_vm_image_sku                                           = "20_04-lts-gen2"
  linux_vm_image_version                                       = "latest"

  # Default NIC - Unique NIC Name per Zone
  linux_vm_default_nic = {
    nic_name      = "nic-${region_code}${product_code}${environment_code}-primary"
    nic_subnet_id = "/subscriptions/59bab8f2-1319-472b-bb69-314d1b034ec0/resourceGroups/demorg1/providers/Microsoft.Network/virtualNetworks/demovnet1/subnets/demosubnet1"
    nic_ip_config = [{
      nic_ip_config_name = "primary"
      nic_ip_config_primary = true
    }]
  }

  # Additional NIC - Unique NIC Name per Zone
  linux_vm_additional_nic = [{
    nic_name      = "nic-${region_code}${product_code}${environment_code}-secondary"
    nic_subnet_id = "/subscriptions/59bab8f2-1319-472b-bb69-314d1b034ec0/resourceGroups/demorg1/providers/Microsoft.Network/virtualNetworks/demovnet1/subnets/demosubnet1"
    nic_ip_config = [{
      nic_ip_config_name = "secondary"
      nic_ip_config_primary = false
    }]
  }]
}



# Environment, Region, and Product Codes
environment_code = "d"   # development
region_code      = "eu1" # East US
product_code     = "pc"  # product code

# VM Sequence Starting Number
sequence_start = 10
# Additional disk details
managed_disk = {
  managed_disk_name         = "data-disk"
  managed_disk_storage_type = "Standard_LRS"
  managed_disks_list        = [128, 64]
  #managed_disk_zone        = 1
  managed_disk_timeout_create = "15m"
  managed_disk_timeout_update = "15m"
  managed_disk_timeout_read   = "15m"
  managed_disk_timeout_delete = "15m"

}
