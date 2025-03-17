locals 

locals {
  # Generate ASG names dynamically based on VM name
  asg_mapped = {
    for vm in local.vm_list : vm.name => {
      asg_name  = format("%s-asg", vm.name) # ASG name will be "vmname-asg"
      nic_names = concat(
        [vm.linux_vm_default_nic.nic_name], # Default NIC
        [for nic in vm.linux_vm_additional_nic : nic.nic_name] # Additional NICs
      )
    }
  }

  # Flatten ASG associations for for_each loop
  asg_attachment = flatten([
    for vm_name, asg in local.asg_mapped : [
      for nic in asg.nic_names : {
        nic_name = nic
        asg_name = asg.asg_name
      }
    ]
  ])

  # Convert to a map for easier lookup
  asg_attachment_map = { for attachment in local.asg_attachment : "${attachment.nic_name}-${attachment.asg_name}" => attachment }
}


locals {
  # Ensure ASG names are correctly mapped
  asg_mapped = {
    for asg in var.asg_config : asg.asg_name => {
      asg_name        = asg.asg_name
      asg_custom_tags = lookup(asg, "asg_custom_tags", {})
      asg_association_nic_names = lookup(asg, "asg_association_nic_names", [])
    }
  }
}
