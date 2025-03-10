module "compute-vm_extension" {
  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.disk_attachment
  ]

  source = "git::https://dev.azure.com/msci-otw/tech-iac/_git/terraform-azurerm-msci-compute-vm_extension?ref=0.6"

  for_each = { for obj in var.vm_config : obj.linux_vm_name => obj }

  #Tags
  tags = local.tags

  #Variables

  vm_extension = concat(
    #OMS Agent Extension
    coalesce(each.value.linux_vm_extension_monitoring_enabled, var.linux_vm_extension_monitoring_enabled) ? [
      {
        #Required
        vm_extension_name      = "MonitoringAgentExtension"
        vm_extension_vm_id     = module.compute-linux_vm.linux_vm_list[each.key].id
        vm_extension_publisher = "Microsoft.EnterpriseCloud.Monitoring"
        vm_extension_type      = "OmsAgentForLinux"
        vm_extension_version   = "1.14"

        #Upgrade
        vm_extension_minor_version_upgrade = true
        vm_extension_auto_upgrade          = false

        #Settings
        vm_extension_failure_suppression_enabled = each.value.linux_vm_extension_monitoring_failure_suppression_enabled           
        vm_extension_settings           = <<SETTINGS
            {
              "workspaceId": "${coalesce(each.value.linux_vm_extension_monitoring_workspace_id, var.linux_vm_extension_monitoring_workspace_id)}",
              "stopOnMultipleConnections": "false"
            }
          SETTINGS
        vm_extension_protected_settings = <<PROTECTED_SETTINGS
            {
              "workspaceKey": "${coalesce(each.value.linux_vm_extension_monitoring_workspace_key, var.linux_vm_extension_monitoring_workspace_key)}"
            }
          PROTECTED_SETTINGS
      }
    ] : [],

    #Custom Script Extension
    coalesce(each.value.linux_vm_extension_custom_script_enabled, var.linux_vm_extension_custom_script_enabled) ? [
      {
        #Required
        vm_extension_name      = "CustomScriptExtension"
        vm_extension_vm_id     = module.compute-linux_vm.linux_vm_list[each.key].id
        vm_extension_publisher = "Microsoft.Compute"
        vm_extension_type      = "CustomScriptExtension"
        vm_extension_version   = "1.9"

        #Upgrade
        vm_extension_minor_version_upgrade = false
        vm_extension_auto_upgrade          = false

        #Settings
        vm_extension_failure_suppression_enabled = each.value.linux_vm_extension_custom_script_failure_suppression_enabled
        vm_extension_settings = <<SETTINGS
            {
              "fileUris": [${format("https://%s.blob.core.windows.net/%s/%s",
        coalesce(each.value.linux_vm_extension_custom_script_blob_storage_account_name, var.linux_vm_extension_custom_script_blob_storage_account_name),
        coalesce(each.value.linux_vm_extension_custom_script_blob_storage_container_name, var.linux_vm_extension_custom_script_blob_storage_container_name),
    coalesce(each.value.linux_vm_extension_custom_script_blob_storage_blob_name, var.linux_vm_extension_custom_script_blob_storage_blob_name))}]
            }
          SETTINGS

    vm_extension_protected_settings = <<PROTECTED_SETTINGS
            {
              "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File ${coalesce(each.value.linux_vm_extension_custom_script_blob_storage_blob_name, var.linux_vm_extension_custom_script_blob_storage_blob_name)} ${coalesce(each.value.linux_vm_extension_custom_script_parameters, var.linux_vm_extension_custom_script_parameters)}",
              "storageAccountName": "${coalesce(each.value.linux_vm_extension_custom_script_blob_storage_account_name, var.linux_vm_extension_custom_script_blob_storage_account_name)}",
              "storageAccountKey": "${coalesce(each.value.linux_vm_extension_custom_script_blob_storage_account_key, var.linux_vm_extension_custom_script_blob_storage_account_key)}"
            }
          PROTECTED_SETTINGS
  }
] : [],

#Encryption Extension
coalesce(each.value.linux_vm_extension_encryption_enabled, var.linux_vm_extension_encryption_enabled) ? [
  {
    #Required
    vm_extension_name      = "EncryptionExtension"
    vm_extension_vm_id     = module.compute-linux_vm.linux_vm_list[each.key].id
    vm_extension_publisher = "Microsoft.Azure.Security"
    vm_extension_type      = "AzureDiskEncryptionForLinux"
    vm_extension_version   = "1.1"

    #Upgrade
    vm_extension_minor_version_upgrade = true
    vm_extension_auto_upgrade          = false

    #Settings
    vm_extension_failure_suppression_enabled = each.value.linux_vm_extension_encryption_failure_suppression_enabled
    vm_extension_settings = <<SETTINGS
                {
                    "EncryptionOperation": "${coalesce(each.value.linux_vm_extension_encryption_operation, var.linux_vm_extension_encryption_operation)}",
                    "KeyVaultURL": "https://${coalesce(each.value.linux_vm_extension_encryption_key_vault_name, var.linux_vm_extension_encryption_key_vault_name)}.vault.azure.net/",
                    "KeyVaultResourceId": "/subscriptions/${var.subscription_id}/resourceGroups/${coalesce(each.value.linux_vm_extension_encryption_key_vault_resource_group, var.linux_vm_extension_encryption_key_vault_resource_group)}/providers/Microsoft.KeyVault/vaults/${coalesce(each.value.linux_vm_extension_encryption_key_vault_name, var.linux_vm_extension_encryption_key_vault_name)}",
                    "KeyEncryptionAlgorithm": "RSA-OAEP",
                    "VolumeType": "${coalesce(each.value.linux_vm_extension_encryption_encrypt_all_disks, var.linux_vm_extension_encryption_encrypt_all_disks) ? "All" : "OS"}",
                    "KekVaultResourceId": "/subscriptions/${var.subscription_id}/resourceGroups/${coalesce(each.value.linux_vm_extension_encryption_key_vault_resource_group, var.linux_vm_extension_encryption_key_vault_resource_group)}/providers/Microsoft.KeyVault/vaults/${coalesce(each.value.linux_vm_extension_encryption_key_vault_name, var.linux_vm_extension_encryption_key_vault_name)}",
                    "KeyEncryptionKeyURL": "https://${coalesce(each.value.linux_vm_extension_encryption_key_vault_name, var.linux_vm_extension_encryption_key_vault_name)}.vault.azure.net/keys/${coalesce(each.value.linux_vm_extension_encryption_key_vault_kek_name, var.linux_vm_extension_encryption_key_vault_kek_name)}/${coalesce(each.value.linux_vm_extension_encryption_key_vault_kek_version, var.linux_vm_extension_encryption_key_vault_kek_version)}"
                }
              SETTINGS
  }
] : [],

#Azure DevOps Agent Extension
coalesce(each.value.linux_vm_extension_ado_agent_enabled, var.linux_vm_extension_ado_agent_enabled) ? [
  {
    #Required
    vm_extension_name      = "ADOAgentExtension"
    vm_extension_vm_id     = module.compute-linux_vm.linux_vm_list[each.key].id
    vm_extension_publisher = "Microsoft.VisualStudio.Services"
    vm_extension_type      = "TeamServicesAgentLinux"
    vm_extension_version   = "1.0"

    #Upgrade
    vm_extension_minor_version_upgrade = true
    vm_extension_auto_upgrade          = false

    #Settings
    vm_extension_failure_suppression_enabled = each.value.linux_vm_extension_ado_agent_failure_suppression_enabled
    vm_extension_settings = <<SETTINGS
                {
                  "VSTSAccountName": "${coalesce(each.value.linux_vm_extension_ado_agent_vsts_account_name, var.linux_vm_extension_ado_agent_vsts_account_name)}",
                  "TeamProject": "${coalesce(each.value.linux_vm_extension_ado_agent_team_project, var.linux_vm_extension_ado_agent_team_project)}",
                  "DeploymentGroup": "${coalesce(each.value.linux_vm_extension_ado_agent_deployment_group, var.linux_vm_extension_ado_agent_deployment_group)}",
                  "AgentName": "${coalesce(each.value.linux_vm_extension_ado_agent_name, var.linux_vm_extension_ado_agent_name)}",
                  "Tags": "${coalesce(each.value.linux_vm_extension_ado_agent_tags, var.linux_vm_extension_ado_agent_tags)}"
                }
              SETTINGS

    vm_extension_protected_settings = <<PROTECTED_SETTINGS
                {
                  "PATToken": "${coalesce(each.value.linux_vm_extension_ado_agent_pat_token, var.linux_vm_extension_ado_agent_pat_token)}"
                }
              PROTECTED_SETTINGS
  }
] : [],

#AAD SSH Extension
    coalesce(each.value.linux_vm_extension_aad_ssh_enabled, var.linux_vm_extension_aad_ssh_enabled) ? [
      {
        #Required
        vm_extension_name      = "AADSSHLoginForLinuxExtension"
        vm_extension_vm_id     = module.compute-linux_vm.linux_vm_list[each.key].id
        vm_extension_publisher = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
        vm_extension_type      = "AADLoginForLinux"
        vm_extension_version   = "1.0"

        #Upgrade
        vm_extension_minor_version_upgrade = true
        vm_extension_auto_upgrade          = false

        #Settings
        vm_extension_failure_suppression_enabled = each.value.linux_vm_extension_aadssh_failure_suppression_enabled           
        vm_extension_settings           = null
        vm_extension_protected_settings = null
      }
    ] : [],
)
}
