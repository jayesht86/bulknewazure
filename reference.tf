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
name = format("%s%s%s%s-%03d", var.region_code, var.product_code, var.environment_code, zone, var.sequence_start + index([for z in config.zone_list : z if z == zone], zone) + 1)



# output "name" {
#   value = local.vm_list
# }

