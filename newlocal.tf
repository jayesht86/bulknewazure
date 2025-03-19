locals {
  tags = merge(var.tags, {
    creation_mode                           = "terraform"
    terraform-azurerm-msci-compute-linux_vm = "True"
  })

  # ✅ Preserve Existing VMs - Prevent Terraform from Destroying & Recreating
  existing_vm = {
    for vm in azurerm_linux_virtual_machine.vm : vm.name => {
      name     = vm.name
      location = vm.location
      zone     = vm.zone
      size     = vm.size
    }
  }

  # ✅ Stable VM Naming - Ensures Existing VMs Are Not Destroyed
  vm_list = flatten([
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

  # ✅ Ensure Stable List of VMs (Merges New + Existing VMs)
  final_vm_list = merge(local.existing_vm, { for vm in local.vm_list : vm.name => vm })

  # ✅ Generate NIC Names Dynamically
  nic_list = {
    for vm in local.final_vm_list : vm.name => {
      default_nic = {
        nic_name      = format("%s-%s-primary", lookup(vm.linux_vm_default_nic, "nic_name", "default-nic"), vm.zone)
        nic_subnet_id = lookup(vm.linux_vm_default_nic, "nic_subnet_id", null)
        nic_ip_config = lookup(vm.linux_vm_default_nic, "nic_ip_config", [])
      }
      additional_nic = [
        for nic_idx, nic in lookup(vm, "linux_vm_additional_nic", []) : {
          nic_name      = format("%s-%s-additional-%02d", lookup(nic, "nic_name", "additional-nic"), vm.zone, nic_idx + 1)
          nic_subnet_id = lookup(nic, "nic_subnet_id", null)
          nic_ip_config = lookup(nic, "nic_ip_config", [])
        }
      ]
    }
  }

  # ✅ Retrieve Existing ASGs to Prevent Re-Creation
  asg_list = {
    for asg in data.azurerm_application_security_group.existing_asgs :
    asg.name => asg.id
  }

  # ✅ Auto-Map ASGs to NICs
  asg_mapped = {
    for asg in coalesce(var.asg_config, []) : asg.asg_name => {
      asg_name                  = asg.asg_name
      asg_custom_tags           = lookup(asg, "asg_custom_tags", {})
      asg_association_nic_names = lookup(asg, "asg_association_nic_names", [])
    }
  }

  # ✅ Flatten ASG-to-NIC Associations for Terraform `for_each`
  asg_attachment_list = flatten([
    for asg in coalesce(var.asg_config, []) : [
      for nic in lookup(asg, "asg_association_nic_names", []) : {
        nic_name = lower(trimspace(nic))
        asg_name = asg.asg_name
      }
    ] if length(lookup(asg, "asg_association_nic_names", [])) > 0
  ])

  # ✅ Convert ASG Associations to a Key-Value Map
  nic_list_keys = keys(local.nic_list)
  asg_attachment_map = {
    for item in local.asg_attachment_list :
      "${item.nic_name}-${item.asg_name}" => item
      if contains(local.nic_list_keys, item.nic_name)
  }
}
