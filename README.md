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
## Task 2: Download the NAMD singularity container and run a namd benchmark using different nmumbers of nodes 
## Task 3: Analice the benchmark´s scalability and visualice the results  

# Task 1: Create a Slurm HPC Cluster


# Task 2: Download the NAMD singularity container and run a namd benchmark using different nmumbers of nodes

# Task 3: Analice the benchmark´s scalability and visualice the results



# Appendix - Deploying the MicroHack environment
To use the Terraform tenplates in this repository to create the MicroHack base environment, the following requirements need to be in place: 

## Requirements

### Terraform state container
The terraform templetes within this repository require a previously created Azure Resource Grou, Storage Account and a BLOB Storage Container as you can see within the main.tf template:

```HCL
...
terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "tfstatemhstorageXXXX"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}
...
```

You can create these iteam using the Azure Portal or the Azure client:

```shell-script
#!/bin/bash

RESOURCE_GROUP_NAME=tf-state-rg
STORAGE_ACCOUNT_NAME=tstatemhstorage$RANDOM
CONTAINER_NAME=terraform-state

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
The name of the storage account needs to be defined within an environment variable or GitHub secret in the following.

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
- TF_CLI_ARGS_init (Backend configuration command line argument that includes the Azure Storage Account that contains the BLOB container, terraform-state, where the terraform state file is stored. Example: export TF_CLI_ARGS_init='-backend-config="storage_account_name=tfstatemhstorage551"')

In addition, if you want to use a service principle instead of usging the Azure client command "az login" the following, additional environment variables need to be defined in a later step:

- ARM_CLIENT_ID
- ARM_CLIENT_SECRET
- ARM_SUBSCRIPTION_ID
- ARM_TENANT_ID

## Run Terraform
To create the Azure infrastructure for the MicroHack you can follow these steps:

1) Install Terraform if required and add it to your PATH.
2) Clone the repository
```Shell
git clone https://github.com/kaneuffe/RTP-microhack
```
3) Create the Azure Service Principle and source the four ARM_* variables
4) Source the TF_VAR_* variables
5) Switch into the terraform subdirectory and adapt the variables.tf file if necessary.
6) Run terraform init:
```Shell
terraform init
```
7) Fix alll issues if there are any and run terraform plan:
```Shell
terraform plan
```
8) If there are issues, fix them and run terraform plan until it gives not further errors. Then deploy the environment using terraform apply:
```Shell
terraform apply
```
9) If there are mayor errors or run terraform destroy and fix the issues before running terraform plan and apply again. You can also use terraform destroy once you want to get rid of the environment. 
```Shell
terraform destroy
```

## Alternative GitHub actions
Instead of running terraform on a terminal on you compute you could use the GitHub actions by cloning the whole repository importing it into a new GitHub repository within your GitHub account.
To run the terraform template using the GitHub actions within the workflows directory, the following secrets need to be defined:

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
- TF_CLI_ARGS

TF_CLI_ARGS needs to point to the Azure storage account where the terraform backend state file is stored. The variable needs to be populated by for example:

```shell-script
  -backend-config="storage_account_name=tfstatemhstorage551" 
```  

To delete the environment, we recommend you do a terraform destroy using on the command line using the instructions above.

## Aknowledgements
Many thanks to Ben and Jerry for their cyclecloud-terraform repository that helped us to create the code to setup the infrastructure. Lots of thanbks also to Trevor who did the groud work for the terraform templates.    





