locals {
  tags = merge(var.tags, {
    creation_mode                           = "terraform"
    terraform-azurerm-msci-compute-linux_vm = "True"
  })

  existing_vms = try({
    for vm in azurerm_linux_virtual_machine.vm : vm.name => {
      name                    = vm.name
      size                    = vm.size
      zone                    = try(vm.zone, null)
      os_disk_size_gb         = try(vm.os_disk.0.disk_size_gb, 128)
      linux_vm_admin_username = try(vm.admin_username, null)
    }
  }, {})

  vm_list = flatten([
    for config in [var.vm_config] : [
      for idx, zone in config.zone_list : {
        name            = format("%s%s%s%s%02d", var.region_code, var.product_code, var.environment_code, zone, idx + 1 + var.sequence_start)
        size            = config.size
        os_disk_size_gb = config.os_disk_size_gb
        zone            = zone
      }
    ]
  ])

  final_vm_list = merge(local.existing_vms, { for vm in local.vm_list : vm.name => vm })

  nic_list = try({
    for nic in data.azurerm_network_interface.existing_nics : nic.name => nic.id
  }, {})

  final_nic_list = merge(local.nic_list, { for vm in local.vm_list : vm.name => {
    nic_name = format("%s-primary", vm.name)
  } })

  asg_list = try({
    for asg in data.azurerm_application_security_group.existing_asgs : asg.name => asg.id
  }, {})

  asg_mapped = merge(local.asg_list, {
    for asg in try(var.asg_config, []) : asg.asg_name => {
      asg_name                  = asg.asg_name
      asg_custom_tags           = lookup(asg, "asg_custom_tags", {})
      asg_association_nic_names = lookup(asg, "asg_association_nic_names", [])
    }
  })

  asg_attachment_map = {
    for item in flatten([
      for asg in try(var.asg_config, []) : [
        for nic in lookup(asg, "asg_association_nic_names", []) : {
          nic_name = lower(trimspace(nic))
          asg_name = asg.asg_name
        }
      ]
    ]) : "${item.nic_name}-${item.asg_name}" => item
    if lookup(local.final_nic_list, item.nic_name, null) != null
  }
}
