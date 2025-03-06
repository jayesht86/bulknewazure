# Resource Group and Location
resource_group_name = "demorg1"
location            = "East US"


# VNet and Subnet Details
vnet_name           = "demovnet1"
subnet_name         = "demosubnet1"

# VM Configuration - List of VM Details
vm_config = [
  {
    linux_vm_name     = "machine1"
    size              = "Standard_D2s_v3"
    zone_list         = ["1", "2"] # "1", "2", "2","2", "3"]
    #vm_count_per_zone = 2
    admin_username    = "adminuser"
    admin_password    = "Password123!"
    os_disk_size_gb   = 30

    linux_vm_default_nic = {
      
        nic_name = "primary-nic"
        nic_subnet_id                      = "/subscriptions/59bab8f2-1319-472b-bb69-314d1b034ec0/resourceGroups/demorg1/providers/Microsoft.Network/virtualNetworks/demovnet1/subnets/demosubnet1"
        #accelerated_networking_enabled = true
        nic_ip_config = [{
          nic_ip_config_name = "primary"
          #private_ip_address_allocation = "Dynamic"
          nic_ip_config_primary = true
        }]
      }
    
  linux_vm_additional_nic =  [{
     nic_name = "secondary-nic"
     nic_subnet_id = "/subscriptions/59bab8f2-1319-472b-bb69-314d1b034ec0/resourceGroups/demorg1/providers/Microsoft.Network/virtualNetworks/demovnet1/subnets/demosubnet1"
     #accelerated_networking_enabled = false
     nic_ip_config = [{
          nic_ip_config_name = "primary"
          #private_ip_address_allocation = "Dynamic"
          nic_ip_config_primary = true
        }]
  } ]


  }

]

# Environment, Region, and Product Codes
environment_code = "d"  # development
region_code      = "eu1"  # East US
product_code     = "pc"  # product code

# VM Sequence Starting Number
sequence_start = 6
# managed_disk = [ {
# # managed_disk_name = "demo1"
# # managed_disk_storage_type = "Standard_LRS"
# # managed_disk_attachment_vm_name = [ "v1", "v2" ]
# 
# } ]
managed_disk = {
    managed_disk_name         = "disk-data"
    managed_disk_storage_type = "Standard_LRS"   
    managed_disks_list       = [20, 30, 40]

    managed_disk_timeout_create = "15m"
    managed_disk_timeout_update = "15m"
    managed_disk_timeout_read   = "15m"
    managed_disk_timeout_delete = "15m"
    managed_disk_attachment_vm_name = ["attachment1", "attachment2"]

 

}
