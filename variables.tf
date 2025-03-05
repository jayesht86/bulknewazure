/* variable "resource_group_name" { 
  type = string 
  }
variable "location" { 
  type = string 
  } */
variable "vnet_name" { 
  type = string 
  }
variable "subnet_name" { 
  type = string 
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
  default = "li"
  validation {
    condition     = length(var.vm_os_type) == 2
    error_message = "OS Type code must be 2 characters."
  }
}

variable "sequence_start" {
  type        = number
  description = "Starting number for VM sequence"
  default     = 2
}

variable "vm_config" {
  type = list(object({
    linux_vm_name     = string
    size              = string
    zone_list         = list(string)
    #vm_count_per_zone = number
    admin_username    = string
    admin_password    = string
    os_disk_size_gb   = number
    #linux_vm_name = string
    #linux_vm_size = string
    #Credentials
    linux_vm_admin_username         = optional(string)
    linux_vm_admin_password         = optional(string)
    linux_vm_password_auth_disabled = optional(bool)
    linux_vm_public_keys = optional(list(object({
      linux_vm_username   = optional(string)
      linux_vm_public_key = optional(string)
    })))
    #Zones
    linux_vm_zone = optional(string)
    #Default NIC
    linux_vm_default_nic = optional(object({
      nic_name                           = string
      nic_subnet_id                      = optional(string)
      nic_dns_servers                    = optional(list(string))
      nic_edge_zone                      = optional(string)
      nic_ip_forwarding_enabled          = optional(bool)
      accelerated_networking_enabled = optional(bool, false)
      nic_internal_dns_name_label        = optional(bool)
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
      nic_name                           = string
      nic_subnet_id                      = optional(string)
      nic_dns_servers                    = optional(list(string))
      nic_edge_zone                      = optional(string)
      nic_ip_forwarding_enabled          = optional(bool)
      accelerated_networking_enabled = optional(bool, false)
      nic_internal_dns_name_label        = optional(bool)
       nic_ip_config = optional(list(object({
        nic_ip_config_name                  = string
        nic_ip_config_private_ip_allocation = optional(string, "Dynamic")
        nic_ip_config_private_ip_address    = optional(string)
        nic_ip_config_public_ip_id          = optional(string)
        nic_ip_config_primary               = optional(bool)
      })) )
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
    linux_vm_host_encryption_enabled = optional(bool)
    linux_vm_custom_data             = optional(string)
    linux_vm_dedicated_host_id       = optional(string)
    linux_vm_boot_diag_uri           = optional(string)
    linux_vm_ultra_disks_enabled     = optional(bool)
    linux_vm_patch_mode              = optional(string)
    linux_vm_bypass_platform_safety_checks_on_user_schedule_enabled    = optional(bool)
    linux_vm_patch_assessment_mode                                     = optional(string)
    linux_vm_reboot_setting          = optional(string)
    linux_vm_identity_type           = optional(string)
    linux_vm_identity_ids            = optional(list(string))
    linux_vm_custom_tags             = optional(map(string))
    #Timeouts
    linux_vm_timeout_create = optional(string)
    linux_vm_timeout_update = optional(string)
    linux_vm_timeout_read   = optional(string)
    linux_vm_timeout_delete = optional(string)

  }))
}
