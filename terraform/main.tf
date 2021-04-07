provider "azurerm" {
  features {}
}

# Backend using a state Terraform file in a storage account
terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    # storage_account_name = var.terraform_state_storage_account_name
    
    # storage_account_name = "tfstatemhstorage"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

# Get the current Azure subcription data
data "azurerm_subscription" "current" {
}

# Create the resource group
resource "azurerm_resource_group" "microhack_rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}