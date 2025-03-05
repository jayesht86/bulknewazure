locals {
    tags = merge(var.tags, {
    creation_mode                           = "terraform"
    terraform-azurerm-msci-compute-linux_vm = "True"
  }) 
  vm_list = flatten([
    for config in var.vm_config : [
      for idx,zone in config.zone_list : {

          name            = format("%s%s%s%s%02d", var.region_code, var.product_code, var.environment_code, zone, idx + 1+ var.sequence_start)
          size            = config.size
          admin_username  = config.admin_username
          admin_password  = config.admin_password
          os_disk_size_gb = config.os_disk_size_gb
          zone            = zone
          #managed_disk_name = 
          

        }
      ]
    ]
  )
 disk_attachments = var.managed_disk != null ? flatten(
    [
      for d in var.managed_disk : [
        for v in d.managed_disk_attachment_vm_name : {
          vm : v,
          disk : d.managed_disk_name,
          lun : d.managed_disk_attachment_lun,
          cache : coalesce(d.managed_disk_attachment_cache, "None"),
          create_option : coalesce(d.managed_disk_attachment_create_option, "Attach"),
          write_accelerator : coalesce(d.managed_disk_attachment_write_accelerator_enabled, false)
        }
      ]
    ]
  ) : null
  disk_attachments2 = var.managed_disk != null ? { for o in local.disk_attachments : "${o.vm} + ${o.disk}" => o }  : {}
  # disk_list = flatten([
  #   for disk in var.managed_disk : [
  #     for idx,zone in config.zone_list : {

  #         name            = format("%s%s%s%s%02d", var.region_code, var.product_code, var.environment_code, zone, idx + 1+ var.sequence_start)
  #         size            = config.size
  #         os_disk_size_gb = config.os_disk_size_gb         

  #       }
  #     ]
  #   ]
  # )
}
#  output "vm_list1" {
#   value = local.vm_list
  
# } 
