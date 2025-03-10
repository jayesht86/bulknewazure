variable "vm_extension" {
  description = <<EOT
    (Required) Manages Virtual Machine Extensions to provide post deployment configuration and run automated tasks.

    REQUIRED

    `vm_extension_name`      - (Required) The name of the virtual machine extension peering. Changing this forces a new resource to be created.

    `vm_extension_vm_id`     - (Required) The ID of the Virtual Machine. Changing this forces a new resource to be created

    `vm_extension_publisher` - (Required) The publisher of the extension, available publishers can be found by using the Azure CLI. Changing this forces a new resource to be created.

    `vm_extension_type`      - (Required) The type of extension, available types for a publisher can be found using the Azure CLI.

    `vm_extension_version`   - (Required) Specifies the version of the extension to use, available versions can be found using the Azure CLI.

    UPGRADE

    `vm_extension_minor_version_upgrade` - (Optional) Specifies if the platform deploys the latest minor version update to the `vm_extension_version` specified. Defaults to true.

    `vm_extension_auto_upgrade` - (Optional) Should the Extension be automatically updated whenever the Publisher releases a new version of this VM Extension? Defaults to false.

    SETTINGS

    `vm_extension_settings` - (Optional) The settings passed to the extension, these are specified as a JSON object in a string.

    `vm_extension_protected_settings` - (Optional) The protected_settings passed to the extension, like settings, these are specified as a JSON object in a string.

    `vm_extension_failure_suppression_enabled` - (Optional) Should failures from the extension be suppressed? Possible values are true or false. Defaults to false.

  EOT
  type = list(object({
    #Required
    vm_extension_name = string
    vm_extension_vm_id = string
    vm_extension_publisher = string
    vm_extension_type = string
    vm_extension_version = string
    #Upgrade
    vm_extension_minor_version_upgrade = optional(bool)
    vm_extension_auto_upgrade = optional(bool)
    #Settings
    vm_extension_settings = optional(string)
    vm_extension_protected_settings = optional(string)
    vm_extension_failure_suppression_enabled = optional(bool)
    #Timeouts
    vm_extension_timeout_create = optional(string)
    vm_extension_timeout_update = optional(string)
    vm_extension_timeout_read = optional(string)
    vm_extension_timeout_delete = optional(string)
    #Extensions
    ##Monitoring Agent Extension
    linux_vm_extension_monitoring_enabled       = optional(bool)
    linux_vm_extension_monitoring_workspace_id  = optional(string)
    linux_vm_extension_monitoring_workspace_key = optional(string)
    linux_vm_extension_monitoring_failure_suppression_enabled = optional(bool,false)
    ##Custom Script Extension
    linux_vm_extension_custom_script_enabled                     = optional(bool)
    linux_vm_extension_custom_script_blob_storage_account_name   = optional(string)
    linux_vm_extension_custom_script_blob_storage_container_name = optional(string)
    linux_vm_extension_custom_script_blob_storage_blob_name      = optional(string)
    linux_vm_extension_custom_script_blob_storage_account_key    = optional(string)
    linux_vm_extension_custom_script_parameters                  = optional(string)
    linux_vm_extension_custom_script_failure_suppression_enabled = optional(bool,false)
    ##Encryption Extension
    linux_vm_extension_encryption_enabled                  = optional(bool)
    linux_vm_extension_encryption_key_vault_name           = optional(string)
    linux_vm_extension_encryption_key_vault_resource_group = optional(string)
    linux_vm_extension_encryption_key_vault_kek_name       = optional(string)
    linux_vm_extension_encryption_key_vault_kek_version    = optional(string)
    linux_vm_extension_encryption_encrypt_all_disks        = optional(bool)
    linux_vm_extension_encryption_operation                = optional(string)
    linux_vm_extension_encryption_failure_suppression_enabled = optional(bool,false)
    ##ADO Agent Extension
    linux_vm_extension_ado_agent_enabled           = optional(bool)
    linux_vm_extension_ado_agent_name              = optional(string)
    linux_vm_extension_ado_agent_vsts_account_name = optional(string)
    linux_vm_extension_ado_agent_team_project      = optional(string)
    linux_vm_extension_ado_agent_deployment_group  = optional(string)
    linux_vm_extension_ado_agent_pat_token         = optional(string)
    linux_vm_extension_ado_agent_tags              = optional(string)
    linux_vm_extension_ado_agent_failure_suppression_enabled = optional(bool,false)
  }))
}

#Global Variables
#Timeouts
variable "vm_extension_timeout_create" {
  description = "Specify timeout for create action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}
variable "vm_extension_timeout_update" {
  description = "Specify timeout for update action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}
variable "vm_extension_timeout_read" {
  description = "Specify timeout for read action. Defaults to 5 minutes."
  type        = string
  default     = "5m"
}
variable "vm_extension_timeout_delete" {
  description = "Specify timeout for delete action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}




