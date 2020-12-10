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

