locals {
  tags = merge(var.tags, {
    creation_mode                           = "terraform"
    terraform-azurerm-msci-compute-linux_vm = "True"
  })
  vm_list = flatten([
    for config in var.vm_config : [
      for idx, zone in config.zone_list : {

        name            = format("%s%s%s%s%02d", var.region_code, var.product_code, var.environment_code, zone, idx + 1 + var.sequence_start)
        size            = config.size
        admin_username  = config.admin_username
        admin_password  = config.admin_password
        os_disk_size_gb = config.os_disk_size_gb
        zone            = zone
        


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
        managed_disk_tier        =var.managed_disk.managed_disk_tier
        managed_disk_max_shares  = var.managed_disk.managed_disk_max_shares
        managed_disk_zone        = var.managed_disk.managed_disk_zone
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
disk_attachments = var.managed_disk != null ? flatten([
  for idx, v in coalesce(var.managed_disk.managed_disk_attachment_vm_name, []) : {
    vm   = v
    disk = format("ddsk-%02d-%s", idx + 1, v) # Ensuring correct name format
    lun  = idx # Assigning LUN based on index
    cache = coalesce(var.managed_disk.managed_disk_attachment_cache, "None")
    create_option = coalesce(var.managed_disk.managed_disk_attachment_create_option, "Attach")
    write_accelerator = coalesce(var.managed_disk.managed_disk_attachment_write_accelerator_enabled, false)
  }
]) : []

  disk_attachments2 = var.managed_disk != null ? { for o in local.disk_attachments : "${o.vm} + ${o.disk}" => o }  : {}

}

output "disk_list" {
  value =  local.vm_managed_disk_extended_list
}

