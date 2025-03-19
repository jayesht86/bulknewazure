
variable "vnet_name" {
  description = "Existing vnet name"
  type        = string
}
variable "subnet_name" {
  description = "Existing vnet name"
  type        = string
}
/* variable "tags" {
  description = "BYO Tags, preferrable from a local on your side"
  type        = map(string)
  default = {
    "env" = "local-dev"
  }
} */

variable "environment_code" {
  type        = string
  description = "Environment Code (a=alpha, d=development, etc.)"
  validation {
    condition     = length(var.environment_code) == 1 && can(regex("^[adpqstuv]$", var.environment_code))
    error_message = "Environment code must be a single character."
  }
}

variable "region_code" {
  type        = string
  description = "Region Code (3 characters, e.g., eu1, wu1)"
  validation {
    condition     = length(var.region_code) == 3
    error_message = "Region code must be 3 characters."
  }
}

variable "product_code" {
  type        = string
  description = "Product Code (2 characters)"
  validation {
    condition     = length(var.product_code) == 2
    error_message = "Product code must be 2 characters."
  }
}

variable "vm_os_type" {
  type        = string
  description = "OS Type Code (2 characters)"
  default     = "li"
  validation {
    condition     = length(var.vm_os_type) == 2
    error_message = "OS Type code must be 2 characters."
  }
}

variable "sequence_start" {
  type        = number
  description = "Starting number for VM sequence"
  default     = 3
}

variable "vm_config" {
  type = object({
    size            = string
    zone_list       = list(string)
    os_disk_size_gb = number
    #linux_vm_size = string
    #Credentials
    linux_vm_admin_username         = optional(string)
    linux_vm_admin_password         = optional(string)
    linux_vm_password_auth_disabled = optional(bool, false)
    linux_vm_public_keys = optional(list(object({
      linux_vm_username   = optional(string)
      linux_vm_public_key = optional(string)
    })))
    #Default NIC
    linux_vm_default_nic = optional(object({
      nic_name                       = string
      nic_subnet_id                  = optional(string)
      nic_dns_servers                = optional(list(string))
      nic_edge_zone                  = optional(string)
      nic_ip_forwarding_enabled      = optional(bool)
      accelerated_networking_enabled = optional(bool, false)
      nic_internal_dns_name_label    = optional(bool)
      nic_ip_config = optional(list(object({
        nic_ip_config_name                  = string
        nic_ip_config_private_ip_allocation = optional(string, "Dynamic")
        nic_ip_config_private_ip_address    = optional(string)
        nic_ip_config_public_ip_id          = optional(string)
        nic_ip_config_primary               = optional(bool)
        nic_ip_config_association_nat_id    = optional(string)
        nic_ip_config_association_lb_id     = optional(string)
        nic_ip_config_association_appgw_ids = optional(list(string))
      })))
      #nic_association_asg_id = optional(string)
      #nic_association_nsg_id = optional(string)
    }))
    #Additional NICs
    linux_vm_additional_nic = optional(list(object({
      nic_name                       = string
      nic_subnet_id                  = optional(string)
      nic_dns_servers                = optional(list(string))
      nic_edge_zone                  = optional(string)
      nic_ip_forwarding_enabled      = optional(bool)
      accelerated_networking_enabled = optional(bool, false)
      nic_internal_dns_name_label    = optional(bool)
      nic_ip_config = optional(list(object({
        nic_ip_config_name                  = string
        nic_ip_config_private_ip_allocation = optional(string, "Dynamic")
        nic_ip_config_private_ip_address    = optional(string)
        nic_ip_config_public_ip_id          = optional(string)
        nic_ip_config_primary               = optional(bool)
      })))
    })))
    #Image
    linux_vm_marketplace_image = optional(bool)
    linux_vm_image_id          = optional(string)
    linux_vm_image_publisher   = optional(string)
    linux_vm_image_offer       = optional(string)
    linux_vm_image_sku         = optional(string)
    linux_vm_image_version     = optional(string)
    #Plan
    linux_vm_image_plan           = optional(bool)
    linux_vm_image_plan_name      = optional(string)
    linux_vm_image_plan_publisher = optional(string)
    linux_vm_image_plan_product   = optional(string)
    #OS Disk
    linux_vm_os_disk_type                      = optional(string)
    linux_vm_os_disk_cache                     = optional(string)
    linux_vm_os_disk_size                      = optional(number)
    linux_vm_os_disk_write_accelerator_enabled = optional(bool)
    linux_vm_os_disk_encryption_set_id         = optional(string)
    linux_vm_os_disk_ephemeral_enabled         = optional(bool)
    linux_vm_os_disk_ephemeral_placement       = optional(string)
    linux_vm_os_disk_encryption_type           = optional(string)
    #SSH Keys
    linux_vm_public_keys = optional(list(object({
      linux_vm_username   = optional(string)
      linux_vm_public_key = optional(string)
    })))
    #Gen2 VM Secure Boot
    linux_vm_secure_boot_enabled = optional(string)
    linux_vm_vtpm_enabled        = optional(string)
    #Additional Capabilities
    linux_vm_host_encryption_enabled                                = optional(bool)
    linux_vm_custom_data                                            = optional(string)
    linux_vm_dedicated_host_id                                      = optional(string)
    linux_vm_boot_diag_uri                                          = optional(string)
    linux_vm_ultra_disks_enabled                                    = optional(bool)
    linux_vm_patch_mode                                             = optional(string)
    linux_vm_bypass_platform_safety_checks_on_user_schedule_enabled = optional(bool)
    linux_vm_patch_assessment_mode                                  = optional(string)
    linux_vm_reboot_setting                                         = optional(string)
    linux_vm_identity_type                                          = optional(string)
    linux_vm_identity_ids                                           = optional(list(string))
    linux_vm_custom_tags                                            = optional(map(string))
    vm_extension_failure_suppression_enabled                        = optional(bool)
    #Extensions
    ##Monitoring Agent Extension
    linux_vm_extension_monitoring_enabled                     = optional(bool)
    linux_vm_extension_monitoring_workspace_id                = optional(string)
    linux_vm_extension_monitoring_workspace_key               = optional(string)
    linux_vm_extension_monitoring_failure_suppression_enabled = optional(bool, false)
    ##Custom Script Extension
    linux_vm_extension_custom_script_enabled                     = optional(bool)
    linux_vm_extension_custom_script_blob_storage_account_name   = optional(string)
    linux_vm_extension_custom_script_blob_storage_container_name = optional(string)
    linux_vm_extension_custom_script_blob_storage_blob_name      = optional(string)
    linux_vm_extension_custom_script_blob_storage_account_key    = optional(string)
    linux_vm_extension_custom_script_parameters                  = optional(string)
    linux_vm_extension_custom_script_failure_suppression_enabled = optional(bool, false)
    ##Encryption Extension
    linux_vm_extension_encryption_enabled                     = optional(bool)
    linux_vm_extension_encryption_key_vault_name              = optional(string)
    linux_vm_extension_encryption_key_vault_resource_group    = optional(string)
    linux_vm_extension_encryption_key_vault_kek_name          = optional(string)
    linux_vm_extension_encryption_key_vault_kek_version       = optional(string)
    linux_vm_extension_encryption_encrypt_all_disks           = optional(bool)
    linux_vm_extension_encryption_operation                   = optional(string)
    linux_vm_extension_encryption_failure_suppression_enabled = optional(bool, false)
    ##ADO Agent Extension
    linux_vm_extension_ado_agent_enabled                     = optional(bool)
    linux_vm_extension_ado_agent_name                        = optional(string)
    linux_vm_extension_ado_agent_vsts_account_name           = optional(string)
    linux_vm_extension_ado_agent_team_project                = optional(string)
    linux_vm_extension_ado_agent_deployment_group            = optional(string)
    linux_vm_extension_ado_agent_pat_token                   = optional(string)
    linux_vm_extension_ado_agent_tags                        = optional(string)
    linux_vm_extension_ado_agent_failure_suppression_enabled = optional(bool, false)
    ##AAD SSH Extension
    linux_vm_extension_aad_ssh_enabled                    = optional(bool)
    linux_vm_extension_aadssh_failure_suppression_enabled = optional(bool, false)
    #Timeouts
    linux_vm_timeout_create = optional(string)
    linux_vm_timeout_update = optional(string)
    linux_vm_timeout_read   = optional(string)
    linux_vm_timeout_delete = optional(string)
    #Timeouts
    linux_vm_timeout_create = optional(string)
    linux_vm_timeout_update = optional(string)
    linux_vm_timeout_read   = optional(string)
    linux_vm_timeout_delete = optional(string)

  })
}
#Global Variables - Used to set default values for all deployed VMs.
#Timeouts
variable "linux_vm_timeout_create" {
  description = "Specify timeout for create action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}
variable "linux_vm_timeout_update" {
  description = "Specify timeout for update action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}
variable "linux_vm_timeout_read" {
  description = "Specify timeout for read action. Defaults to 5 minutes."
  type        = string
  default     = "5m"
}
variable "linux_vm_timeout_delete" {
  description = "Specify timeout for delete action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}

#Credentials
# variable "linux_vm_admin_username" {
#   description = "(Required) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created. If this variable filled, will be used for all VMs to be deployed, unless overridden."
#   type        = string
#   default     = null
# }
# variable "linux_vm_admin_password" {
#   description = "(Required) The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created. If this variable filled, will be used for all VMs to be deployed, unless overridden."
#   type        = string
#   default     = null
#   sensitive   = true
# }
variable "linux_vm_password_auth_disabled" {
  description = "(Optional) Should Password Authentication be disabled on this Virtual Machine? Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  default     = true
}
variable "linux_vm_public_keys" {
  description = <<EOT
    A list of objects with the usernames and public keys to be applied on the scaleset.
    One of either `linux_vm_admin_password` or `linux_vm_public_keys` must be specified.

    `linux_vm_username`   - (Required) The Username for which this Public SSH Key should be configured.

    `linux_vm_public_key` - (Required) The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format.

    EOT
  type = list(object({
    linux_vm_username   = optional(string)
    linux_vm_public_key = optional(string)
  }))
  default = []
}

#Subnet
variable "linux_vm_nic_subnet_id" {
  description = "Reference to a subnet in which NICs will be created. Required when private_ip_address_version is IPv4. This is a Global Variable."
  type        = string
  default     = null
}

#Images
variable "linux_vm_marketplace_image" {
  description = <<EOT
    <!-- markdownlint-disable-file MD033 MD012 -->
    (Required) Whether the image source used for deployment is the Azure Marketplace. Default to false.
    When set to true, the following properties needs to be set: `linux_vm_image_publisher`, `linux_vm_image_offer`, `linux_vm_image_sku`, `linux_vm_image_version`.
    When set to false, the following properties needs to be set: `linux_vm_image_id`.
    EOT
  type        = bool
  default     = false
}
variable "linux_vm_image_id" {
  description = "(Optional) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}
variable "linux_vm_image_publisher" {
  description = "(Optional) Specifies the publisher of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}
variable "linux_vm_image_offer" {
  description = "(Optional) Specifies the offer of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}
variable "linux_vm_image_sku" {
  description = "(Optional) Specifies the SKU of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}
variable "linux_vm_image_version" {
  description = "(Optional) Specifies the version of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}

#Plan
variable "linux_vm_image_plan" {
  description = <<EOT
    <!-- markdownlint-disable-file MD033 MD012 -->
    (Required) Whether the image source is the Azure Marketplace and require plan block . Default to false.
    When set to true, the following properties needs to be set: `linux_vm_image_plan_name`, `linux_vm_image_plan_publisher`, `linux_vm_image_plan_product`.
    EOT
  type        = bool
  default     = false
}
variable "linux_vm_image_plan_name" {
  description = "(Optional) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}
variable "linux_vm_image_plan_publisher" {
  description = "(Optional) Specifies the publisher of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}
variable "linux_vm_image_plan_product" {
  description = "(Optional) Specifies the offer of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}

#License
variable "linux_vm_license_type" {
  description = "(Optional) Specifies the BYOL Type for this Virtual Machine. Possible values are RHEL_BYOS and SLES_BYOS."
  type        = string
  default     = null
  validation {
    condition     = (var.linux_vm_license_type == null || var.linux_vm_license_type == "RHEL_BYOS" || var.linux_vm_license_type == "SLES_BYOS")
    error_message = "Possible values are RHEL_BYOS and SLES_BYOS."
  }
}
#Custom Data
# variable "linux_vm_custom_data" {
#   description = "(Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
#   type        = string
#   default     = null
# }

# #Dedicated Hosts
# variable "linux_vm_dedicated_host_id" {
#   description = "(Optional) The ID of a Dedicated Host where this machine should be run on. Conflicts with `dedicated_host_group_id`. If this variable filled, will be used for all VMs to be deployed, unless overridden."
#   type        = string
#   default     = null
# }

# #Boot Diag
# variable "linux_vm_boot_diag_uri" {
#   description = "(Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor."
#   type        = string
#   default     = null
# }

# #Encryption
# variable "linux_vm_host_encryption_enabled" {
#   description = "(Optional) Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host? Defaults to false."
#   type        = bool
#   default     = false
# }

variable "linux_vm_os_disk_encryption_set_id" {
  description = "(Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. The Disk Encryption Set must have the Reader Role Assignment scoped on the Key Vault - in addition to an Access Policy to the Key Vault."
  type        = string
  default     = null
}

#Gen2 VM Secure Boot
# variable "linux_vm_secure_boot_enabled" {
#   description = "(Optional) Specifies whether secure boot should be enabled on the virtual machine. Changing this forces a new resource to be created."
#   type        = bool
#   default     = false
# }
# variable "linux_vm_vtpm_enabled" {
#   description = "(Optional) Specifies whether vTPM should be enabled on the virtual machine. Changing this forces a new resource to be created."
#   type        = bool
#   default     = false
# }
variable "linux_vm_bypass_platform_safety_checks_on_user_schedule_enabled" {
  description = "(Optional) Specifies if bypass platform safety checks on user schedule enabled are Enabled for the Linux Virtual Machine."
  type        = bool
  default     = false
}
variable "linux_vm_patch_assessment_mode" {
  description = "(Optional) Specifies the mode of patch assessment to this Linux Virtual Machine. Possible values are ImageDefault and AutomaticByPlatform. Defaults to ImageDefault"
  type        = string
  default     = "ImageDefault"
}
#Ephemeral Disk
variable "linux_vm_os_disk_ephemeral_enabled" {
  description = "(Optional) Whether to enable the Ephemeral OS Disk capability on the VM. Changing this forces a new resource to be created. For more information check https://docs.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks-deploy. When enabled it will set `linux_vm_os_disk_cache` to ReadOnly."
  type        = bool
  default     = false
}
