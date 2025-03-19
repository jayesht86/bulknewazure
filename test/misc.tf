### Providers
#IaC_Non-Prod
provider "azurerm" {
  #tenant_id       = "7a9376d4-7c43-480f-82ba-a090647f651d" #MSCI OFFICE 365
  #client_id       = "4dd6b8b8-6fcf-4b43-80f2-d3e335256657" #IaC_Non-Prod_owner
  subscription_id            = "59bab8f2-1319-472b-bb69-314d1b034ec0" #"d357f413-8679-4148-9db8-ecc3db0617a1" #IaC_Non-Prod
  skip_provider_registration = true
  features {
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

#TF Version
terraform {
  required_version = ">=1.3.4"
}

#Provider Versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.69.0"
    }
  }
}

#Backend
terraform {
  backend "azurerm" {
    #tenant_id            = "7a9376d4-7c43-480f-82ba-a090647f651d" #MSCI OFFICE 365
    subscription_id      = "59bab8f2-1319-472b-bb69-314d1b034ec0" #IaC_Non-Prod
    resource_group_name  = "rgrp-dva2-ic-terratest"               #East US 2 RGRP
    storage_account_name = "saccdva2icterratest003"
    container_name       = "tfstate-compute-linux-vm-bulk"
    key                  = "tfstate-compute-linux-vm-bulk.terraform.tfstate"
    snapshot             = true
  }
}

#Client Config Current
data "azurerm_client_config" "current" {
}

#Remote States
data "terraform_remote_state" "va2_infrastructure" {
  backend = "azurerm"

  config = {
    tenant_id            = "7a9376d4-7c43-480f-82ba-a090647f651d" #MSCI OFFICE 365
    subscription_id      = "d357f413-8679-4148-9db8-ecc3db0617a1" #IaC_Non-Prod
    resource_group_name  = "rgrp-dva2-ic-tfstate"                 #East US 2 RGRP
    storage_account_name = "saccdva2ictfstate001"
    container_name       = "tfstate-va2-infrastructure"
    key                  = "iac-nonprod-va2-infrastructure.terraform.tfstate"
  }
}

data "terraform_remote_state" "va2_security" {
  backend = "azurerm"

  config = {
    tenant_id            = "7a9376d4-7c43-480f-82ba-a090647f651d" #MSCI OFFICE 365
    subscription_id      = "d357f413-8679-4148-9db8-ecc3db0617a1" #IaC_Non-Prod
    resource_group_name  = "rgrp-dva2-ic-tfstate"                 #East US 2 RGRP
    storage_account_name = "saccdva2ictfstate001"
    container_name       = "tfstate-va2-security"
    key                  = "iac-nonprod-va2-security.terraform.tfstate"
  }
}

data "terraform_remote_state" "va2_terratest" {
  backend = "azurerm"

  config = {
    tenant_id            = "7a9376d4-7c43-480f-82ba-a090647f651d" #MSCI OFFICE 365
    subscription_id      = "d357f413-8679-4148-9db8-ecc3db0617a1" #IaC_Non-Prod
    resource_group_name  = "rgrp-dva2-ic-tfstate"                 #East US 2 RGRP
    storage_account_name = "saccdva2ictfstate001"
    container_name       = "tfstate-va2-terratest"
    key                  = "iac-nonprod-va2-terratest.terraform.tfstate"
  }
}
