# *** RTP-microshack ***
Github repository for the Azure CycleCloud RTP microhack
# Content

# Contents
[Introduction](#introduction)

[Objectives](#objectives)

[Scenario](#scenario)

[Lab](#lab)

[Prerequisites](#prerequisites)

[Scenario 1: Single region Virtual WAN with Default Routing](#scenario-1-single-region-virtual-wan-with-default-routing)

[Scenario 2: Add a branch connection](#scenario-2-add-a-branch-connection)

[Scenario 3: Multi-regional Virtual WAN](#scenario-3-multi-regional-virtual-wan)

[Scenario 4: Isolated Spokes and Shared Services Spoke](#scenario-4-isolated-spokes-and-shared-services-spoke)

[Scenario 5 (Optional): Filter traffic through a Network Virtual Appliance](#scenario-5-optional-filter-traffic-through-a-network-virtual-appliance)

[Scenario 6 (Optional): Secured Hubs](#scenario-6-optional-secured-hubs)

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
