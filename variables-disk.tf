variable "managed_disk" {
    type = list(object({
    managed_disk_name         = string
    managed_disk_storage_type = string
    #Create Options
    managed_disk_create_option            = optional(string)
    managed_disk_marketplace_reference_id = optional(string)
    managed_disk_gallery_reference_id     = optional(string)
    managed_disk_source_resource_id       = optional(string)
    managed_disk_source_uri               = optional(string)
    managed_disk_source_storage_id        = optional(string)
    managed_disk_os_type                  = optional(string)
    managed_disk_hyper_v_generation       = optional(string)
    managed_disk_upload_size_bytes        = optional(number)
    #Disk Options
    managed_disk_size_gb     = optional(number)
    managed_disk_sector_size = optional(number)
    managed_disk_tier        = optional(string)
    managed_disk_max_shares  = optional(number)
    managed_disk_zone        = optional(number)
    #Ultra SSD Options
    managed_disk_iops_read_write = optional(string)
    managed_disk_iops_read_only  = optional(string)
    managed_disk_mbps_read_write = optional(string)
    managed_disk_mbps_read_only  = optional(string)
    #Network Options
    managed_disk_public_access_enabled = optional(bool)
    managed_disk_access_policy         = optional(string)
    managed_disk_access_id             = optional(string)
    #Encryption
    managed_disk_encryption_set_id = optional(string)
    #Timeouts
    managed_disk_timeout_create = optional(string)
    managed_disk_timeout_update = optional(string)
    managed_disk_timeout_read   = optional(string)
    managed_disk_timeout_delete = optional(string)
    #Attachments
    managed_disk_attachment_vm_name                   = optional(list(string))
    managed_disk_attachment_lun                       = optional(string)
    managed_disk_attachment_cache                     = optional(string)
    managed_disk_attachment_create_option             = optional(string)
    managed_disk_attachment_write_accelerator_enabled = optional(bool)
  }))
  default = null
}

#Global Vars
#Timeouts
# variable "managed_disk_timeout_create" {
#   description = "Specify timeout for create action. Defaults to 15 minutes."
#   type        = string
#   default     = "15m"
# }
# variable "managed_disk_timeout_update" {
#   description = "Specify timeout for update action. Defaults to 15 minutes."
#   type        = string
#   default     = "15m"
# }
# variable "managed_disk_timeout_read" {
#   description = "Specify timeout for read action. Defaults to 5 minutes."
#   type        = string
#   default     = "5m"
# }
# variable "managed_disk_timeout_delete" {
#   description = "Specify timeout for delete action. Defaults to 15 minutes."
#   type        = string
#   default     = "15m"
# }

#Encryption
variable "managed_disk_encryption_set_id" {
  description = "(Optional) The ID of a Disk Encryption Set which should be used to encrypt this Managed Disk."
  type        = string
  default     = null
}
