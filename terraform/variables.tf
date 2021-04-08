variable "prefix" {
  description = "The Prefix used for all CycleCloud VM resources"
  default = "mh"
}

variable "location" {
  description = "The Azure Region in which to run CycleCloud"
  default = "westeurope"
}

variable "nteams" {
  description = "Number of teams"
  default = "10"
}

variable "machine_type" {
  description = "The Azure Machine Type for the CycleCloud VM"
  default = "Standard_D8s_v3"
}

variable "cyclecloud_server_name" {
  description =  "The private hostname for the CycleCloud VM"
  default = "ccserver"
}

variable "admin_username" {
  description = "The username for the CycleCloud VM admin user"
  default = "azuser"
}

variable "admin_key_data" {
  description = "The public SSH key for the CycleCloud VM admin user"
}

variable "cyclecloud_username" {
  description = "The username for the initial CycleCloud admin user"
  default = "ccadmin"
}

variable "cyclecloud_password" {
  description = "The initial password for the CycleCloud admin user"
}

variable "cyclecloud_public_access_address_prefixes"{
  description = "PublicIP address ranges allowed to connect to CycleCloud"
}

# Storage account name can contain only lowercase letters and numbers.
variable "cyclecloud_storage_account" {
  description = "Name prefix of storage account to use for Azure CycleCloud storage locker"
  default = "ccstorage"
}