provider "azurerm" {
  features {}
}

# Backend using a state Terraform file in a storage account (storage_account_name has been defined in the command line options for terraorm)
terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
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