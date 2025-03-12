module "network-asg" {
  source = "git::https://dev.azure.com/msci-otw/tech-iac/_git/terraform-azurerm-msci-network-asg?ref=0.3"
  for_each = { for obj in local.vm_list : obj.name => obj }
  #Subscription
  subscription_id = var.subscription_id

  #Resource Group
  resource_group_object = data.azurerm_resource_group.existing_rg

  #Tags
  tags = local.tags

  #ASG
  asg = var.asg
}
