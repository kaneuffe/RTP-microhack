# Create the VNET
resource "azurerm_virtual_network" "microhack_vnet" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.microhack_rg.location
  resource_group_name = azurerm_resource_group.microhack_rg.name
  address_space       = ["10.0.0.0/16"]
}

# Create a subnet for the Azure CycleCLoud server
resource "azurerm_subnet" "microhack_cc_subnet" {
  name                 = "${var.prefix}-cc-subnet"
  virtual_network_name = azurerm_virtual_network.microhack_vnet.name
  resource_group_name  = azurerm_resource_group.microhack_rg.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# Create a subnet for the ANF endpoint
resource "azurerm_subnet" "microhack_anf_subnet" {
  name                 = "${var.prefix}-anf-subnet"
  virtual_network_name = azurerm_virtual_network.microhack_vnet.name
  resource_group_name  = azurerm_resource_group.microhack_rg.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# Create a subnet for each of the microhack teams to be used for the HPC cluster
resource "azurerm_subnet" "microhack_compute_subnet" {
  count                = var.nteams  
  name                 = "${var.prefix}-compute-${count.index}-subnet"
  virtual_network_name = azurerm_virtual_network.microhack_vnet.name
  resource_group_name  = azurerm_resource_group.microhack_rg.name
  address_prefixes     = ["10.${count.index}.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# Create a Network Security Group
resource "azurerm_network_security_group" "microhack_cc_subnet_nsg" {
    name                = "${var.prefix}-subnet-nsg"
    location            = azurerm_resource_group.microhack_rg.location
    resource_group_name = azurerm_resource_group.microhack_rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefixes    = list(var.cyclecloud_public_access_address_prefixes)
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefixes    = list(var.cyclecloud_public_access_address_prefixes)
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "HTTPS"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefixes    = list(var.cyclecloud_public_access_address_prefixes)
        destination_address_prefix = "*"
    }
}

# Create a Network Security Group
resource "azurerm_network_security_group" "microhack_compute_subnet_nsg" {
    name                = "${var.prefix}-subnet-nsg"
    location            = azurerm_resource_group.microhack_rg.location
    resource_group_name = azurerm_resource_group.microhack_rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefixes    = list(var.cyclecloud_public_access_address_prefixes)
        destination_address_prefix = "*"
    }
}

# Assign the network security group to the CC subnet
resource "azurerm_subnet_network_security_group_association" "microhack_cc_subnet_nsg_assign" {
    subnet_id                 = azurerm_subnet.microhack_cc_subnet.id
    network_security_group_id = azurerm_network_security_group.microhack_cc_subnet_nsg.id
}

# Assign the netwrok security group to the Compute subnets
resource "azurerm_subnet_network_security_group_association" "microhack_compute_subnet_nsg_assign" {
    count                     = var.nteams
    subnet_id                 = azurerm_subnet.microhack_compute_subnet.*.id
    network_security_group_id = azurerm_network_security_group.microhack_compute_subnet_nsg.id
}