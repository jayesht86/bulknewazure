variable "storage_account_type" {
  description = "The type of storage account for the disks (Standard_LRS, Premium_LRS)."
  type        = string
  default     = "Standard_LRS"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "network_interfaces" {
  type = list(object({
    name                           = optional(string)
    accelerated_networking_enabled = optional(bool, false)
    nic_ip_config = optional(list(object({
      name                          = optional(string)
      private_ip_address_allocation = optional(string, "Dynamic")
      primary                       = optional(bool, false)
    })), [])
  }))
  default = []
}

variable "os_disk_size_gb" {
  type    = number
  default = 64
}
variable "nic_ids" {
  type    = list(string)
  default = []
}

variable "data_disk_ids" {
  type    = list(string)
  default = []
}
variable "linux_vm_os_disk_encryption_type" {
  description = "Encryption type for OS Disk"
  type        = string
  default     = null
}

variable "linux_vm_secure_boot_enabled" {
  description = "Enable secure boot for Gen2 VM"
  type        = bool
  default     = false
}

variable "linux_vm_vtpm_enabled" {
  description = "Enable vTPM for Gen2 VM"
  type        = bool
  default     = false
}

variable "linux_vm_host_encryption_enabled" {
  description = "Enable encryption at host level"
  type        = bool
  default     = false
}

variable "linux_vm_custom_data" {
  description = "Base64-encoded custom data for VM initialization"
  type        = string
  default     = null
}

variable "linux_vm_dedicated_host_id" {
  description = "Dedicated Host ID for VM placement"
  type        = string
  default     = null
}

variable "linux_vm_ultra_disks_enabled" {
  description = "Enable Ultra SSD capability"
  type        = bool
  default     = false
}

variable "linux_vm_boot_diag_uri" {
  description = "Storage Account URI for Boot Diagnostics"
  type        = string
  default     = null
}

variable "linux_vm_identity_type" {
  description = "Type of Managed Service Identity"
  type        = string
  default     = null
}

variable "linux_vm_identity_ids" {
  description = "User Assigned Managed Identity IDs"
  type        = list(string)
  default     = []
}

variable "linux_vm_custom_tags" {
  description = "Custom tags for VM"
  type        = map(string)
  default     = {}
}
variable "tags" {
  description = "BYO Tags, preferrable from a local on your side"
  type        = map(string)
  default = {
    "env" = "local-dev"
  }
}
variable "subscription_id" {
  description = "ID of the Subscription"
  type        = string
  validation {
    condition     = can(regex("\\b[0-9a-f]{8}\\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\\b[0-9a-f]{12}\\b", var.subscription_id))
    error_message = "Must be a valid subscription id. Ex: 9e4e50cf-5a4a-4deb-a466-9086cd9e365b."
  }
  default = "59bab8f2-1319-472b-bb69-314d1b034ec0"
}

# variable "admin_username" {
#   type    = string
#   default = "user1jayesh"

# }
# variable "admin_password" {
#   type    = string
#   default = "user1jayesh@!23"
# }
# variable "zone" {
#   type    = string
#   default = "1"
# }
# variable "subnet_id" {
#   type    = string
#   default = "/subscriptions/{subcriptions_id}/resourceGroups/providers/Microsoft.Network/virtualNetworks/{vnet_name}/subnets/{subnet_name}"
# }

# variable "disk_size" {
#   description = "The size of the disks for the VMs in GB."
#   type        = number
#   default     = 100
# }
# variable "disk_count" {
#   description = "Number of additional data disks to attach per VM."
#   type        = number
#   default     = 0
# }
# variable "vm_name" {
#   description = "The name of the VM associated with the disk"
#   type        = string
#   default     = "vm1"
# }
# variable "zones" {
#   type    = list(string)
#   default = ["1"]
# }
# variable "name" {
#   type    = string
#   default = "1wee"
# }
# variable "size" {
#   type    = string
#   default = "20"
# }
