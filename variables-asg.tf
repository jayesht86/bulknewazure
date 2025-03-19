variable "asg_config" {
  description = <<EOT
  (Required) The Application Security Groups to be created.

  `asg_name`        - (Required) Specifies the name of the Application Security Group. Changing this forces a new resource to be created.

  `asg_custom_tags` - (Optional) A mapping of custom tags which should be appended to the default tags.

  `asg_association_nic_names` - (Optional) The names of the NIC, where this ASG should be associated.

  EOT
  type = set(object({
    asg_name                  = string
    asg_custom_tags           = optional(map(string))
    asg_association_nic_names = optional(list(string))
  }))
  default = []
}
