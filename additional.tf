locals {
  ### ✅ Fetch existing resources from state ###
  existing_vms   = try(data.terraform_remote_state.compute_linux_vm_bulk.outputs.linux_vm_list, {})
  existing_nics  = try(data.terraform_remote_state.compute_linux_vm_bulk.outputs.nic_list, {})
  existing_disks = try(data.terraform_remote_state.compute_linux_vm_bulk.outputs.disk_list, {})
  existing_asgs  = try(data.terraform_remote_state.compute_linux_vm_bulk.outputs.asg_list, {})

  ### ✅ Merge existing and new resources ###
  final_vm_list = merge(local.existing_vms, { for vm in local.vm_list : vm.name => vm })
  final_nic_list = merge(local.existing_nics, { for nic in local.nic_list : nic.nic_name => nic })
  final_disk_list = merge(local.existing_disks, { for disk in local.vm_managed_disk_extended_list : disk.managed_disk_name => disk })
  final_asg_list = merge(local.existing_asgs, { for asg in local.asg_mapped : asg.asg_name => asg })
}
