module "compute-managed_disk" {
  source = "git::https://dev.azure.com/msci-otw/tech-iac/_git/terraform-azurerm-msci-compute-managed_disk?ref=0.10"

  #Subscription
  subscription_id = var.subscription_id

  #Resource Group
  resource_group_object = data.azurerm_resource_group.existing_rg

  #Tags
  tags = local.tags

  #Variables

  #Global Variables used by all deployments
  ##Timeouts
   managed_disk_timeout_create = var.managed_disk.managed_disk_timeout_create
   managed_disk_timeout_update = var.managed_disk.managed_disk_timeout_update
   managed_disk_timeout_read   = var.managed_disk.managed_disk_timeout_read
   managed_disk_timeout_delete = var.managed_disk.managed_disk_timeout_delete

  #Disk List

  managed_disk = local.vm_managed_disk_extended_list

}
