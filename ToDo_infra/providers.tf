terraform {
    required_version = ">= 1.11.0"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "4.32.0"
        }
    }
    backend "azurerm" {
        resource_group_name  = "ranjeet_rg"
        storage_account_name = "rajpootstgacc"
        container_name       = "ranjeetcontainerr"
        key                  = "prod.todo.tfstate"
    }
}

provider "azurerm" {
    features {}
    subscription_id = "bc541da1-a034-4462-a34b-a447b3fcbeee"
    tenant_id       = "6db3c59e-ddf1-44d4-ba62-32e3a492286ff"
}

