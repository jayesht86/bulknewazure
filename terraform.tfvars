# Resource Group and Location
resource_group_name = "demorg1"
location            = "East US"

# VNet and Subnet Details
vnet_name           = "demovnet1"
subnet_name         = "demosubnet1"

# VM Configuration - List of VM Details
vm_config = [
  {
    size              = "Standard_D2s_v3"
    zone_list         = ["1", "2"] # "1", "2", "2","2", "3"]
    #vm_count_per_zone = 2
    admin_username    = "adminuser"
    admin_password    = "Password123!"
    os_disk_size_gb   = 30

    linux_vm_default_nic = {
      
        #name = "primary-nic"
        accelerated_networking_enabled = true
        nic_ip_config = [{
          name = "primary-ipconfig"
          private_ip_address_allocation = "Dynamic"
          primary = true
        }]
      }
    
  linux_vm_additional_nic =  {
     name = "secondary-nic"
     accelerated_networking_enabled = false
     nic_ip_config = [{
          name = "secondary-ipconfig"
          private_ip_address_allocation = "Dynamic"
          primary = false
        }]
  } 

  }#,

]

# Environment, Region, and Product Codes
environment_code = "d"  # development
region_code      = "eu1"  # East US
product_code     = "pc"  # product code

# VM Sequence Starting Number
sequence_start = 6
