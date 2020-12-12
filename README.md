# RTP-microshack
A Github repository for the Azure CycleCloud RTP MicroHack

# Contents
[Scenario](#scenario)

[Objectives](#objectives)

[Pre-Requisites](#pre-requisites)

[Lab](#lab)

[Appendix - Deploying the MicroHack environment](#appendix)

# Scenario
An university department wants to run a set of molecular dynamics simulations as part of a COVID-19 research initiative within a reasonable amount of time. They decide to use the NAMD (Not (just) Another Molecular Dynamics program) software running on a High Performance Computing (HPC) cluster. As they do not have this infrastructure on-premises, they decide to leverage Microsoft Azure Cloud.

# Objectives
This MicroHack is a walkthrough of creating an High Performance Computing (HPC) cluster on Azure and to run a typical HPC workload on it including the visualization of the redults.
The type of HPC workload manager we are going to use in this MicroHack is Slurm (Simple Linux Utility for Resource Management - https://slurm.schedmd.com/cpu_management.html). 

After completing this MicroHack you will:
-	Know how to deploy a Slurm HPC cluster on Azure through Azure CycleCloud
- Run an HPC application on a Slurm HPC cluster

# Pre-Requeisites 
This MicroHack explores the creation of a High Performance Computing (HPC) Cluster on Microsoft Azure, to run the NAMD application leveraging a singularity container and to visualize the results ones the application ran.

![image](images/microhack_architecture.png)

The lab start with an pre-deployed Azure base environment including the following components:
- Virtual Network (VNET).
- Subnet to host the Azure CycleCloud server VM.
- One compute subnet per team  a HPC Cluster per team.
- One storage subnet pre team the HPC Cluster nodes to access the Azure NetApp NFS volumes.
- Set of Network Security Groups to limit the internet access to the environment. 
- Azure Blob Storage account to store the Azure CycleCloud project data.
- Azure NetApp Files (ANF) storage account with one capacity pool and a pre-created NFS volume for each of the teams.
- Azure CycleCloud server VM with and attached Azure Active Directory Managed Identity to be authorized to create HPC Cluster. 
- Azure container registry (ACR) to host the NAMD application singularity container.
- NAMD application sngularity container.
- Azure Virtual Machine Image containing the necessary configuration to create a graphical HPC cluster head node.

# Lab
## Task 1: Create a Slurm HPC Cluster
## Task 2: 
## Task 3:

# Appendix - Deploying the MicroHack environment
To use the Terraform tenplates in this repository to create the MicroHack base environment, the following requirements need to be in place: 

## Requirements

### Terraform
The terraform templetes within this repository require a previously created Azure Resource Grou, Storage Account and a BLOB Storage Container as you can see within the main.tf template:

terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "tfstatemhstorage"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

You can create these iteam using the Azure Portal or the AZ client:

```
#!/bin/bash

RESOURCE_GROUP_NAME=tstate
STORAGE_ACCOUNT_NAME=tstate$RANDOM
CONTAINER_NAME=tstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"
```

### Permissions
To be able to run this terraform template yourself or a already created service principle need to have the following permissions:
- OWNER rights for the subscription in scope or
- CONTRIBUTOR and USER ACCESS ADMINISTRATOR for the subscription in scope

### Environment variables
To run the templates, youn need to set the following environment variables:
- TF_VAR_admin_username (CycleCloud VM OS administrator username)
- TF_VAR_admin_password (CycleCLoud VM OS administrator password - to make password authentication work, please change "disable_password_authentication = false" in main.tf)
- TF_VAR_admin_key_data (CyclecCloud VM OS administrator public ssh key)
- TF_VAR_cyclecloud_username (CycleCloud GUI administrator username)
- TF_VAR_cyclecloud_password (CycleCloud GUI administrator username)
- TF_VAR_cyclecloud_public_access_address_prefixes (Comma deparated list of IP adress ranges allowed to access the environment, e.g. 120.10.1.3/32, 123.10.2.4/24)

In addition, if you want to use a service principle instead of "az login" the following, additional environment variables need to be defined:

- ARM_CLIENT_ID
- ARM_CLIENT_SECRET
- ARM_SUBSCRIPTION_ID
- ARM_TENANT_ID

### GitHub actions
To run the terraform template using the GitHub actions within the workflows directory, the follwing secrets need to be defined:
- TF_ARM_CLIENT_ID
- TF_ARM_CLIENT_SECRET
- TF_ARM_SUBSCRIPTION_ID
- TF_ARM_TENANT_ID
- TF_VAR_ADMIN_USERNAME
- TF_VAR_ADMIN_PASSWORD
- TF_VAR_ADMIN_KEY_DATA
- TF_VAR_CYCLECLOUD_USERNAME
- TF_VAR_CYCLECLOUD_PASSWORD
- TF_VAR_CYCLECLOUD_PUBLIC_ACCESS_ADDRESS_PREFIXES


