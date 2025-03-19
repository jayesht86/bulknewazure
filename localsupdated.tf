locals {
  ### ✅ Fetch existing resources from Terraform state ###
  existing_vms   = try(data.terraform_remote_state.compute_linux_vm_bulk.outputs.linux_vm_list, {})
  existing_nics  = try(data.terraform_remote_state.compute_linux_vm_bulk.outputs.nic_list, {})
  existing_disks = try(data.terraform_remote_state.compute_linux_vm_bulk.outputs.disk_list, {})
  existing_asgs  = try(data.terraform_remote_state.compute_linux_vm_bulk.outputs.asg_list, {})

  ### ✅ VM List - Merging Existing and New VMs ###
  new_vm_list = flatten([
    for config in [var.vm_config] : [
      for idx, zone in config.zone_list : {
        name            = format("%s%s%s%s%02d", var.region_code, var.product_code, var.environment_code, zone, idx + var.sequence_start)
        size            = config.size
        os_disk_size_gb = config.os_disk_size_gb
        zone            = zone
        linux_vm_admin_username         = config.linux_vm_admin_username
        linux_vm_admin_password         = config.linux_vm_admin_password
        linux_vm_password_auth_disabled = config.linux_vm_password_auth_disabled
        linux_vm_image_publisher        = config.linux_vm_image_publisher
        linux_vm_image_offer            = config.linux_vm_image_offer
        linux_vm_image_sku              = config.linux_vm_image_sku
        linux_vm_image_version          = config.linux_vm_image_version
        linux_vm_default_nic            = lookup(config, "linux_vm_default_nic", null)
        linux_vm_additional_nic         = lookup(config, "linux_vm_additional_nic", [])
      }
    ]
  ])

  ### ✅ Ensuring Stable VM List (Merges Old + New) ###
  final_vm_list = merge(local.existing_vms, { for vm in local.new_vm_list : vm.name => vm })

  ### ✅ NIC List - Merging Existing and New NICs ###
  new_nic_list = flatten([
    for vm in local.final_vm_list : concat(
      [{ vm_name = vm.name, nic_name = vm.linux_vm_default_nic.nic_name }],
      [for nic in vm.linux_vm_additional_nic : { vm_name = vm.name, nic_name = nic.nic_name }]
    )
  ])
  final_nic_list = merge(local.existing_nics, { for nic in local.new_nic_list : nic.nic_name => nic })

  ### ✅ Managed Disk List - Merging Existing and New Disks ###
  new_disk_list = flatten([
    for idx, vm in local.final_vm_list : [
      for disk_idx, disk_size in var.managed_disk.managed_disks_list : {
        vm                = vm.name
        disk              = format("ddsk-%02d-%s", disk_idx + 1, vm.name)
        size_gb           = disk_size
      }
    ]
  ])
  final_disk_list = merge(local.existing_disks, { for disk in local.new_disk_list : disk.disk => disk })

  ### ✅ ASG List - Merging Existing and New ASGs ###
  new_asg_mapped = {
    for asg in coalesce(var.asg_config, []) : asg.asg_name => {
      asg_name                  = asg.asg_name
      asg_custom_tags           = lookup(asg, "asg_custom_tags", {})
      asg_association_nic_names = lookup(asg, "asg_association_nic_names", [])
    }
  }
  final_asg_list = merge(local.existing_asgs, local.new_asg_mapped)

  ### ✅ ASG-to-NIC Association ###
  asg_attachment_list = flatten([
    for asg in coalesce(var.asg_config, []) : [
      for nic in lookup(asg, "asg_association_nic_names", []) : {
        nic_name = lower(trimspace(nic))
        asg_name = asg.asg_name
      }
    ] if length(lookup(asg, "asg_association_nic_names", [])) > 0
  ])

  ### ✅ Convert ASG Associations into Key-Value Map ###
  asg_attachment_map = {
    for item in local.asg_attachment_list :
      "${item.nic_name}-${item.asg_name}" => item if contains(keys(local.final_nic_list), item.nic_name)
  }
}
