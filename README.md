# RTP-microshack
A Github repository for the Azure CycleCloud RTP microhack

# Contents
[Introduction](#introduction)

[Objectives](#objectives)

[Scenario](#scenario)

[Lab](#lab)

[Prerequisites](#prerequisites)

# Introduction
This MicroHack explores the creation of a High Perfromance Computing (HPC) Cluster on Microsoft Azure, to run the NAMD application leveraging a singularity container and to visualize the result ones the application ran. 

The lab start with an pre-deployed Azure base environment including the following components:
- Virtual Network (VNET)
- Subnet to host the Azure CycleCloud server VM
- One compute subnet per team  a HPC Cluster per team
- One storage subnet pre team the HPC Cluster nodes to access the Azure NetApp files share
- Set of Netwrok Security Groups to limit the internet access to the environment 
- Azure Blob Storage account to store the Azure CycleCloud project data
- Azure NetApp Files (ANF) shared NFS storage account with one volume and one pre-created NFS share for each team
- Azure CycleCloud server VM with and attached Azure Active Directory Managed Indentity to be authorized to create HPC Cluster. 
- Azure container registry (ACR) to host the NAMD application singularity image.
- NAMD application sngularity container.
- Azure Virtual Machine Image containing the necessary configuration to create a grahical HPC cluster head node. 


# Objectives
After completing this MicroHack you will:
-	Know how to deploy and HPC cluster on Azure through Azure CycleCloud

# Scenario

# Lab

# Prerequisites
