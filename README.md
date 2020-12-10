# RTP-microshack
A Github repository for the Azure CycleCloud RTP microhack

# Contents
[Scenario](#scenario)

[Objectives](#objectives)

[Pre-Requisits](#pre-requisits)

[Lab](#lab)

[Appendix - Deploying the microhack environment](#appendix)

# Scenario
An univerity wants to run a set of molecular dynamics simulations as part of a COVID-19 research initiastive within a resonable amount of time. They decide to use the NAMD (Not (just) Another Molecular Dynamics program) software running on a High Perfromance Computing cluster. As they do not have this infrastructure on-premises, they decide to leverage Microsoft Azure Cloud.

# Objectives
After completing this MicroHack you will:
-	Know how to deploy and HPC cluster on Azure through Azure CycleCloud

# Pre-Requeisits 
This MicroHack explores the creation of a High Perfromance Computing (HPC) Cluster on Microsoft Azure, to run the NAMD application leveraging a singularity container and to visualize the result ones the application ran.



The lab start with an pre-deployed Azure base environment including the following components:
- Virtual Network (VNET).
- Subnet to host the Azure CycleCloud server VM.
- One compute subnet per team  a HPC Cluster per team.
- One storage subnet pre team the HPC Cluster nodes to access the Azure NetApp NFS volumes.
- Set of Netwrok Security Groups to limit the internet access to the environment. 
- Azure Blob Storage account to store the Azure CycleCloud project data.
- Azure NetApp Files (ANF) storage account with one capacity pool and a pre-created NFS volume for each of the teams.
- Azure CycleCloud server VM with and attached Azure Active Directory Managed Indentity to be authorized to create HPC Cluster. 
- Azure container registry (ACR) to host the NAMD application singularity image.
- NAMD application sngularity container.
- Azure Virtual Machine Image containing the necessary configuration to create a grahical HPC cluster head node.

# Lab
## Task 1: Create a Slurm HPC Cluster
## Task 2: 
## Task 3:

# Appendix - Deploying the microhack environment

