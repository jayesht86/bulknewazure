locals {
  tags = merge(var.tags, {
    creation_mode                           = "terraform"
    terraform-azurerm-msci-compute-linux_vm = "True"
  })
  vm_list = flatten([
    for config in [var.vm_config] : [
      for idx, zone in config.zone_list : {
        #VM_Config
        name            = format("%s%s%s%s%02d", var.region_code, var.product_code, var.environment_code, zone, idx + 1 + var.sequence_start)
        size            = config.size
        os_disk_size_gb = config.os_disk_size_gb
        zone            = zone
        #VM_Image_details
        linux_vm_image_publisher = config.linux_vm_image_publisher
        linux_vm_image_offer     = config.linux_vm_image_offer
        linux_vm_image_sku       = config.linux_vm_image_sku
        linux_vm_image_version   = config.linux_vm_image_version
        #VM_Admin
        linux_vm_admin_username         = config.linux_vm_admin_username
        linux_vm_admin_password         = config.linux_vm_admin_password
        linux_vm_password_auth_disabled = config.linux_vm_password_auth_disabled
        # NIC Details
        linux_vm_default_nic    = lookup(config, "linux_vm_default_nic", null)
        linux_vm_additional_nic = lookup(config, "linux_vm_additional_nic", [])
        # Default NIC 
        linux_vm_default_nic = {
          nic_name      = format("%s-%s-primary", lookup(config.linux_vm_default_nic, "nic_name", "default-nic"), zone)
          nic_subnet_id = lookup(config.linux_vm_default_nic, "nic_subnet_id", null)
          nic_ip_config = lookup(config.linux_vm_default_nic, "nic_ip_config", [])
        }
        # Additional NICs 
        linux_vm_additional_nic = [
          for nic_idx, nic in lookup(config, "linux_vm_additional_nic", []) : {
            nic_name      = format("%s-%s-additional-%02d", lookup(nic, "nic_name", "additional-nic"), zone, nic_idx + 1)
            nic_subnet_id = lookup(nic, "nic_subnet_id", null)
            nic_ip_config = lookup(nic, "nic_ip_config", [])
        }]
        #OMS Agent Extension		
        vm_extension_failure_suppression_enabled = config.vm_extension_failure_suppression_enabled
        #Extension_Custom_Scripts
        linux_vm_extension_custom_script_enabled                     = config.linux_vm_extension_custom_script_enabled
        linux_vm_extension_custom_script_blob_storage_container_name = config.linux_vm_extension_custom_script_blob_storage_container_name
        linux_vm_extension_custom_script_blob_storage_blob_name      = config.linux_vm_extension_custom_script_blob_storage_blob_name
        linux_vm_extension_custom_script_blob_storage_account_name   = config.linux_vm_extension_custom_script_blob_storage_account_name
        linux_vm_extension_custom_script_blob_storage_account_key    = config.linux_vm_extension_custom_script_blob_storage_account_key
        linux_vm_extension_custom_script_failure_suppression_enabled = config.linux_vm_extension_custom_script_failure_suppression_enabled
        #Extension_AAD_&_SSH
        linux_vm_extension_aad_ssh_enabled                    = config.linux_vm_extension_aad_ssh_enabled
        linux_vm_extension_aadssh_failure_suppression_enabled = config.linux_vm_extension_aadssh_failure_suppression_enabled
        #Extension_ADO
        linux_vm_extension_ado_agent_failure_suppression_enabled = config.linux_vm_extension_ado_agent_failure_suppression_enabled
        linux_vm_extension_ado_agent_enabled                     = config.linux_vm_extension_ado_agent_enabled
        linux_vm_extension_ado_agent_vsts_account_name           = config.linux_vm_extension_ado_agent_vsts_account_name
        linux_vm_extension_ado_agent_team_project                = config.linux_vm_extension_ado_agent_team_project
        linux_vm_extension_ado_agent_deployment_group            = config.linux_vm_extension_ado_agent_deployment_group
        linux_vm_extension_ado_agent_name                        = config.linux_vm_extension_ado_agent_name
        linux_vm_extension_ado_agent_tags                        = config.linux_vm_extension_ado_agent_tags
        linux_vm_extension_ado_agent_pat_token                   = config.linux_vm_extension_ado_agent_pat_token
        #Extension_Monitoring
        linux_vm_extension_monitoring_failure_suppression_enabled = config.linux_vm_extension_monitoring_failure_suppression_enabled
        linux_vm_extension_monitoring_enabled                     = config.linux_vm_extension_monitoring_enabled
        linux_vm_extension_monitoring_workspace_id                = config.linux_vm_extension_monitoring_workspace_id
        linux_vm_extension_monitoring_workspace_id                = config.linux_vm_extension_monitoring_workspace_id
        linux_vm_extension_monitoring_workspace_key               = config.linux_vm_extension_monitoring_workspace_key
        #Extension_Encryption
        linux_vm_extension_encryption_key_vault_kek_version       = config.linux_vm_extension_encryption_key_vault_kek_version
        linux_vm_extension_encryption_key_vault_kek_name          = config.linux_vm_extension_encryption_key_vault_kek_name
        linux_vm_extension_encryption_failure_suppression_enabled = config.linux_vm_extension_encryption_failure_suppression_enabled
        linux_vm_extension_encryption_enabled                     = config.linux_vm_extension_encryption_enabled
        linux_vm_extension_encryption_operation                   = config.linux_vm_extension_encryption_operation
        linux_vm_extension_encryption_key_vault_name              = config.linux_vm_extension_encryption_operation
        linux_vm_extension_encryption_key_vault_resource_group    = config.linux_vm_extension_encryption_operation
        linux_vm_extension_encryption_encrypt_all_disks           = config.linux_vm_extension_encryption_encrypt_all_disks
        linux_vm_extension_encryption_key_vault_resource_group    = config.linux_vm_extension_encryption_key_vault_resource_group
        linux_vm_extension_encryption_key_vault_name              = config.linux_vm_extension_encryption_key_vault_name
      }
    ]
    ]
  )

  effective_disk_count = var.managed_disk != null ? length(var.managed_disk.managed_disks_list) : 0

  vm_managed_disk_extended_list = flatten([
    for idx, obj in local.vm_list : [
      for count_idx in range(local.effective_disk_count) : {

        managed_disk_name                     = "ddsk-${format("%02d", count_idx + 1)}-${obj.name}"
        managed_disk_storage_type             = var.managed_disk.managed_disk_storage_type
        managed_disk_create_option            = var.managed_disk.managed_disk_create_option
        managed_disk_marketplace_reference_id = var.managed_disk.managed_disk_marketplace_reference_id
        managed_disk_gallery_reference_id     = var.managed_disk.managed_disk_gallery_reference_id
        managed_disk_source_resource_id       = var.managed_disk.managed_disk_source_resource_id
        managed_disk_source_uri               = var.managed_disk.managed_disk_source_uri
        managed_disk_source_storage_id        = var.managed_disk.managed_disk_source_storage_id
        managed_disk_os_type                  = var.managed_disk.managed_disk_os_type
        managed_disk_hyper_v_generation       = var.managed_disk.managed_disk_hyper_v_generation
        managed_disk_upload_size_bytes        = var.managed_disk.managed_disk_upload_size_bytes
        #Disk Options
        managed_disk_size_gb     = var.managed_disk.managed_disks_list != null ? (length(var.managed_disk.managed_disks_list) > 0 ? var.managed_disk.managed_disks_list[count_idx] : 128) : 128
        managed_disk_sector_size = var.managed_disk.managed_disk_sector_size
        managed_disk_tier        = var.managed_disk.managed_disk_tier
        managed_disk_max_shares  = var.managed_disk.managed_disk_max_shares
        managed_disk_zone        = obj.zone #var.managed_disk.managed_disk_zone
        #Ultra SSD Options
        managed_disk_iops_read_write = var.managed_disk.managed_disk_iops_read_write
        managed_disk_iops_read_only  = var.managed_disk.managed_disk_iops_read_only
        managed_disk_mbps_read_write = var.managed_disk.managed_disk_mbps_read_write
        managed_disk_mbps_read_only  = var.managed_disk.managed_disk_mbps_read_only
        #Network Options
        managed_disk_public_access_enabled = var.managed_disk.managed_disk_public_access_enabled
        managed_disk_access_policy         = var.managed_disk.managed_disk_access_policy
        managed_disk_access_id             = var.managed_disk.managed_disk_access_id
        #Encryption
        managed_disk_encryption_set_id = var.managed_disk.managed_disk_encryption_set_id
        #Timeouts
        managed_disk_timeout_create = var.managed_disk.managed_disk_timeout_create
        managed_disk_timeout_update = var.managed_disk.managed_disk_timeout_update
        managed_disk_timeout_read   = var.managed_disk.managed_disk_timeout_read
        managed_disk_timeout_delete = var.managed_disk.managed_disk_timeout_delete
        #Attachments
        managed_disk_attachment_vm_name                   = var.managed_disk.managed_disk_attachment_vm_name #[obj.name]
        managed_disk_attachment_lun                       = var.managed_disk.managed_disk_attachment_lun
        managed_disk_attachment_cache                     = var.managed_disk.managed_disk_attachment_cache
        managed_disk_attachment_create_option             = var.managed_disk.managed_disk_attachment_create_option
        managed_disk_attachment_write_accelerator_enabled = var.managed_disk.managed_disk_attachment_write_accelerator_enabled

    }]
  ])

  vm_names = [for vm in local.vm_list : vm.name]
  disk_attachments = var.managed_disk != null ? flatten([
    for idx, vm in local.vm_names : [
      for disk_idx, disk_size in var.managed_disk.managed_disks_list : {
        vm                = vm
        disk              = format("ddsk-%02d-%s", disk_idx + 1, vm)
        lun               = disk_idx
        cache             = coalesce(var.managed_disk.managed_disk_attachment_cache, "None")
        create_option     = coalesce(var.managed_disk.managed_disk_attachment_create_option, "Attach")
        write_accelerator = coalesce(var.managed_disk.managed_disk_attachment_write_accelerator_enabled, false)
      }
    ]
  ]) : []

  disk_attachments2 = var.managed_disk != null ? { for o in local.disk_attachments : "${o.vm} + ${o.disk}" => o } : {}

  vm_lists = azurerm_linux_virtual_machine.vm


  asg_list = {
    for asg in data.azurerm_application_security_group.existing_asgs :
    asg.name => asg.id
  }
  nic_names = flatten([
    for vm in local.vm_list : concat(
      [vm.linux_vm_default_nic.nic_name],
      [for nic in vm.linux_vm_additional_nic : nic.nic_name]
    )
  ])

  # Extract NIC IDs from data source
  nic_list = { for nic in data.azurerm_network_interface.existing_nics : nic.name => nic.id }
  asg_mapped = {
    for asg in var.asg_config : asg.asg_name => {
      asg_name                  = asg.asg_name
      asg_custom_tags           = lookup(asg, "asg_custom_tags", {})
      asg_association_nic_names = lookup(asg, "asg_association_nic_names", [])
    }
  }

  # Flatten ASG-to-NIC associations for Terraform `for_each`
  asg_attachment_list = flatten([
    for asg in var.asg_config : [
      for nic in asg.asg_association_nic_names : {
        nic_name = lower(trimspace(nic))
        asg_name = asg.asg_name
      }
    ] if length(asg.asg_association_nic_names) > 0
  ])

  # Convert ASG associations into a key-value map for Terraform `for_each`
  asg_attachment_map = {
  for item in local.asg_attachment_list : "${item.nic_name}-${item.asg_name}" => item if contains(keys(local.nic_list), item.nic_name) }
}







# output "disk_list" {
#   value =  local.vm_managed_disk_extended_list
# }

