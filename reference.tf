locals {

  #Labels
  labels = merge({
    creation_mode                         = "terraform"
    terraform-google-msci-compute-vm-bulk = "true"
  }, var.vm_labels)

  #VM List
  vm_list = {
    for idx, zone in var.vm_zones_list : "${var.vm_environment_code}${var.vm_region_code}${var.vm_product_code}${zone}${var.vm_os_type_letter}${var.vm_os_role_name}${format("%0${var.vm_number_of_sequence_number_field}d", idx + 1 + var.vm_add_to_numbering)}" =>
    {
      name : "${var.vm_environment_code}${var.vm_region_code}${var.vm_product_code}${zone}${var.vm_os_type_letter}${var.vm_os_role_name}${format("%0${var.vm_number_of_sequence_number_field}d", idx + 1 + var.vm_add_to_numbering)}",
      VirtualMachineZone : "${var.vm_region}-${zone}",
      description : var.vm_description,
      domain : var.vm_domain,
      sku : var.vm_sku,
      additional_nics : var.vm_additional_nics
    }
  }


  vm_extended_list = {
    for idx, zone in var.vm_zones_list : "${var.vm_environment_code}${var.vm_region_code}${var.vm_product_code}${zone}${var.vm_os_type_letter}${var.vm_os_role_name}${format("%0${var.vm_number_of_sequence_number_field}d", idx + 1 + var.vm_add_to_numbering)}" => {
      name                        = "${var.vm_environment_code}${var.vm_region_code}${var.vm_product_code}${zone}${var.vm_os_type_letter}${var.vm_os_role_name}${format("%0${var.vm_number_of_sequence_number_field}d", idx + 1 + var.vm_add_to_numbering)}"
      zone                        = "${var.vm_region}-${zone}"
      description                 = var.vm_description
      domain                      = var.vm_domain
      sku                         = var.vm_sku
      min_cpu_platform            = var.vm_min_cpu_platform
      deletion_protection_enabled = var.vm_deletion_protection_enabled
      enable_display              = var.vm_enable_display
      labels = merge({
        creation_mode                         = "terraform"
        terraform-google-msci-compute-vm-bulk = "true"
      }, var.vm_labels)
      tags                            = var.vm_tags
      metadata                        = var.vm_metadata
      metadata_script                 = var.vm_metadata_script
      resource_policies               = var.vm_resource_policies
      service_account_email           = var.vm_service_account_email
      service_account_scopes          = var.vm_service_account_scopes
      shielded_config_enabled         = var.vm_shielded_config_enabled
      secure_boot_enabled             = var.vm_secure_boot_enabled
      vtpm_enabled                    = var.vm_vtpm_enabled
      integrity_monitoring_enabled    = var.vm_integrity_monitoring_enabled
      boot_disk                       = var.vm_boot_disk
      local_disk                      = var.vm_local_disk
      ip_forward_enabled              = var.vm_ip_forward_enabled
      network_performance_tier        = var.vm_network_performance_tier
      network_performance_enabled     = var.vm_network_performance_enabled
      domain_join_enabled             = var.vm_domain_join_enabled
      domain_join_account             = var.vm_domain_join_account
      domain_join_gcloud_project      = var.vm_domain_join_gcloud_project
      domain_join_organizational_unit = var.vm_domain_join_organizational_unit
      nested_virtualization_enabled   = var.vm_nested_virtualization_enabled
      smt_disabled                    = var.vm_smt_disabled
      visible_core_count              = var.vm_visible_core_count
      default_nic                     = var.vm_default_nics
      additional_nics                 = var.vm_additional_nics
    }
  }


  effective_count = var.additional_disks != null ? length(var.additional_disks.size) : 0

  vm_disk_extended_list = flatten([
    for idx, obj in local.vm_extended_list : [
      for count_index in range(local.effective_count) : {
        vm_name : obj.name
        disk_name : "ddsk-${format("%02d", count_index + 1)}-${obj.name}"
        disk_type : var.additional_disks.type
        disk_size : var.additional_disks.size != null ? (length(var.additional_disks.size) > 0 ? var.additional_disks.size[count_index] : 128) : 128
        disk_block_size : var.additional_disks.block_size
        disk_provisioned_iops : var.additional_disks.provisioned_iops
        disk_multi_writer_enabled : var.additional_disks.multi_writer_enabled
        disk_labels : var.additional_disks.labels
        disk_encryption_enabled : var.additional_disks.encryption_enabled
        disk_encryption : var.additional_disks.encryption
        disk_snapshot_policy : var.additional_disks.snapshot_policy
        disk_attachment_zone : obj.zone
        disk_attachment_mode : var.additional_disks.disk_attachment_mode
      }
    ]
  ])


  vm_disk_list = flatten([
    for idx, obj in local.vm_extended_list : [
      for count_index in range(local.effective_count) : {
        vm_name : obj.name
        disk_name : "ddsk-${format("%02d", count_index + 1)}-${obj.name}"
        disk_type : var.additional_disks.type
        disk_size : var.additional_disks.size != null ? (length(var.additional_disks.size) > 0 ? var.additional_disks.size[count_index] : 128) : 128
        disk_snapshot_policy : var.additional_disks.snapshot_policy
        disk_attachment_zone : obj.zone
        disk_attachment_mode : var.additional_disks.disk_attachment_mode
      }
    ]
  ])



}
eu1pcd1-011
eu1pcd2-011
eu1pcd3-011
name = format("%s%s%s%s-%03d", var.region_code, var.product_code, var.environment_code, zone, var.sequence_start + index([for z in config.zone_list : z if z == zone], zone) + 1)

name = format("%s%s%s%s-%03d", var.region_code, var.product_code, var.environment_code, zone, local.zone_sequence[zone] + var.sequence_start + 1)
zone_sequence_update = zone_sequence
zone_sequence = merge(zone_sequence_update, {for k,v in zone_sequence_update : k => k == zone ? v + 1 : v})

zone_sequence = {
    for zone in distinct(var.vm_config.zone_list) : zone => 0
  }


# output "name" {
#   value = local.vm_list
# }

zone_sequence_init = {
    for zone in distinct(var.vm_config.zone_list) : zone => 0
  }

  zone_sequence = zone_sequence_init

name = format("%s%s%s%s-%03d", var.region_code, var.product_code, var.environment_code, zone, local.zone_sequence[zone] + var.sequence_start + 1)

zone_sequence = merge(local.zone_sequence, {for k,v in local.zone_sequence : k => k == zone ? v + 1 : v})

disk_attachments2 = var.managed_disk != null ? { for o in local.disk_attachments : "${o.vm} + ${o.disk} + ${o.lun}" => o } : {}


  vm_managed_disk_extended_list = flatten([
    for obj in local.vm_list : [
      for disk_idx, disk_size in var.managed_disk.managed_disks_list : {

        managed_disk_name                     = format("ddsk-%s-%03d", obj.name, disk_idx + 1)
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

  disk_attachments2 = var.managed_disk != null ? { for o in local.disk_attachments : "${o.vm} + ${o.disk} + ${o.lun}" => o } : {}
