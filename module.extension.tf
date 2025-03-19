module "compute-vm_extension" {
  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.disk_attachment
  ]

  source = "git::https://dev.azure.com/msci-otw/tech-iac/_git/terraform-azurerm-msci-compute-vm_extension?ref=0.6"

  #for_each = merge({ "extension" = var.vm_extension }, {})
  for_each = { for obj in local.vm_list : obj.name => obj }
  # Tags
  tags = local.tags

  # Variables
  vm_extension = concat(
    # OMS Agent Extension
    coalesce(each.value.linux_vm_extension_monitoring_enabled, false) ? [
      {
        vm_extension_name      = "MonitoringAgentExtension"
        vm_extension_vm_id     = local.vm_lists[each.value.name].id
        vm_extension_publisher = "Microsoft.EnterpriseCloud.Monitoring"
        vm_extension_type      = "OmsAgentForLinux"
        vm_extension_version   = "1.14"

        vm_extension_minor_version_upgrade = true
        vm_extension_auto_upgrade          = false

        vm_extension_failure_suppression_enabled = each.value.linux_vm_extension_monitoring_failure_suppression_enabled

        vm_extension_settings = <<SETTINGS
            {
              "workspaceId": "${coalesce(each.value["linux_vm_extension_monitoring_workspace_id"], "default-workspace-id")}",
              "stopOnMultipleConnections": "false"
            }
        SETTINGS

        vm_extension_protected_settings = <<PROTECTED_SETTINGS
            {
              "workspaceKey": "${coalesce(each.value["linux_vm_extension_monitoring_workspace_key"], "default-workspace-key")}"
            }
        PROTECTED_SETTINGS
      }
    ] : [],

    # Custom Script Extension
    coalesce(each.value["linux_vm_extension_custom_script_enabled"], false) ? [
      {
        vm_extension_name      = "CustomScriptExtension"
        vm_extension_vm_id     = local.vm_lists[each.value.name].id
        vm_extension_publisher = "Microsoft.Azure.Extensions"
        vm_extension_type      = "CustomScript"
        vm_extension_version   = "1.9"

        vm_extension_minor_version_upgrade = false
        vm_extension_auto_upgrade          = false

        vm_extension_failure_suppression_enabled = each.value["linux_vm_extension_custom_script_failure_suppression_enabled"]

        vm_extension_settings = <<SETTINGS
            {
              "fileUris": ["https://${coalesce(each.value["linux_vm_extension_custom_script_blob_storage_account_name"], "default-storage")}.blob.core.windows.net/${coalesce(each.value["linux_vm_extension_custom_script_blob_storage_container_name"], "default-container")}/${coalesce(each.value["linux_vm_extension_custom_script_blob_storage_blob_name"], "default-blob")}"]
            }
        SETTINGS

        vm_extension_protected_settings = <<PROTECTED_SETTINGS
            {
              "commandToExecute": "bash ${coalesce(each.value["linux_vm_extension_custom_script_blob_storage_blob_name"], "default.sh")}",
              "storageAccountName": "${coalesce(each.value["linux_vm_extension_custom_script_blob_storage_account_name"], "default-storage")}",
              "storageAccountKey": "${coalesce(each.value["linux_vm_extension_custom_script_blob_storage_account_key"], "default-key")}"
            }
        PROTECTED_SETTINGS
      }
    ] : [],

    # Encryption Extension
    coalesce(each.value["linux_vm_extension_encryption_enabled"], false) ? [
      {
        vm_extension_name      = "EncryptionExtension"
        vm_extension_vm_id     = local.vm_lists[each.value.name].id
        vm_extension_publisher = "Microsoft.Azure.Security"
        vm_extension_type      = "AzureDiskEncryptionForLinux"
        vm_extension_version   = "1.1"

        vm_extension_minor_version_upgrade = true
        vm_extension_auto_upgrade          = false

        vm_extension_failure_suppression_enabled = each.value["linux_vm_extension_encryption_failure_suppression_enabled"]

        vm_extension_settings = <<SETTINGS
                {
                    "EncryptionOperation": "${coalesce(each.value["linux_vm_extension_encryption_operation"], "default-operation")}",
                    "KeyVaultURL": "https://${coalesce(each.value["linux_vm_extension_encryption_key_vault_name"], "default-keyvault")}.vault.azure.net/",
                    "KeyVaultResourceId": "/subscriptions/${var.subscription_id}/resourceGroups/${coalesce(each.value["linux_vm_extension_encryption_key_vault_resource_group"], "default-rg")}/providers/Microsoft.KeyVault/vaults/${coalesce(each.value["linux_vm_extension_encryption_key_vault_name"], "default-keyvault")}",
                    "KeyEncryptionAlgorithm": "RSA-OAEP",
                    "VolumeType": "${coalesce(each.value["linux_vm_extension_encryption_encrypt_all_disks"], false) ? "All" : "OS"}",
                    "KekVaultResourceId": "/subscriptions/${var.subscription_id}/resourceGroups/${coalesce(each.value["linux_vm_extension_encryption_key_vault_resource_group"], "default-rg")}/providers/Microsoft.KeyVault/vaults/${coalesce(each.value["linux_vm_extension_encryption_key_vault_name"], "default-keyvault")}",
                    "KeyEncryptionKeyURL": "https://${coalesce(each.value.linux_vm_extension_encryption_key_vault_name, "default-keyvault")}.vault.azure.net/keys/${coalesce(each.value.linux_vm_extension_encryption_key_vault_kek_name, "default-kek")}/${coalesce(each.value.linux_vm_extension_encryption_key_vault_kek_version, "default-version")}"
                }
        SETTINGS
      }
    ] : [],

    # Azure DevOps Agent Extension
    coalesce(each.value["linux_vm_extension_ado_agent_enabled"], false) ? [
      {
        vm_extension_name      = "ADOAgentExtension"
        vm_extension_vm_id     = local.vm_lists[each.value.name].id
        vm_extension_publisher = "Microsoft.VisualStudio.Services"
        vm_extension_type      = "TeamServicesAgentLinux"
        vm_extension_version   = "1.0"

        vm_extension_minor_version_upgrade = true
        vm_extension_auto_upgrade          = false

        vm_extension_failure_suppression_enabled = each.value["linux_vm_extension_ado_agent_failure_suppression_enabled"]

        vm_extension_settings = <<SETTINGS
            {
              "VSTSAccountName": "${coalesce(each.value["linux_vm_extension_ado_agent_vsts_account_name"], "default-account")}",
              "TeamProject": "${coalesce(each.value["linux_vm_extension_ado_agent_team_project"], "default-project")}",
              "DeploymentGroup": "${coalesce(each.value["linux_vm_extension_ado_agent_deployment_group"], "default-group")}",
              "AgentName": "${coalesce(each.value["linux_vm_extension_ado_agent_name"], "default-agent")}",
              "Tags": "${coalesce(each.value["linux_vm_extension_ado_agent_tags"], "default-tags")}"
            }
        SETTINGS

        vm_extension_protected_settings = <<PROTECTED_SETTINGS
            {
              "PATToken": "${coalesce(each.value["linux_vm_extension_ado_agent_pat_token"], "default-token")}"
            }
        PROTECTED_SETTINGS
      }
    ] : [],

    # AAD SSH Extension
    coalesce(each.value["linux_vm_extension_aad_ssh_enabled"], false) ? [
      {
        vm_extension_name      = "AADSSHLoginForLinuxExtension"
        vm_extension_vm_id     = local.vm_lists[each.value.name].id
        vm_extension_publisher = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
        vm_extension_type      = "AADLoginForLinux"
        vm_extension_version   = "1.0"

        vm_extension_minor_version_upgrade = true
        vm_extension_auto_upgrade          = false

        vm_extension_failure_suppression_enabled = each.value["linux_vm_extension_aadssh_failure_suppression_enabled"]

        vm_extension_settings           = null
        vm_extension_protected_settings = null
      }
    ] : []
  )
}
