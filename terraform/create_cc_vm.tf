# Create random number for the storage account name
resource "random_id" "storage_account" {
  byte_length = 8
}

# Create CycleCloud storage account
resource "azurerm_storage_account" "microhack_cc_locker" {
  name                     = "${var.prefix}${lower(random_id.storage_account.hex)}sa" 
  location                 = azurerm_resource_group.microhack_rg.location 
  resource_group_name      = azurerm_resource_group.microhack_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create a public IP for the CycleCloud server
resource "azurerm_public_ip" "microhack_cc_public_ip" {
  name                     = "${var.prefix}-public-ip"
  location                 = azurerm_resource_group.microhack_rg.location 
  resource_group_name      = azurerm_resource_group.microhack_rg.name
  allocation_method        = "Dynamic"
}

# Create the network interface for the CycleCloud server
resource "azurerm_network_interface" "microhack_cc_nic" {
  name                = "${var.prefix}-cc-nic"
  location            = azurerm_resource_group.microhack_rg.location
  resource_group_name = azurerm_resource_group.microhack_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.microhack_cc_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.microhack_cc_public_ip.id
  }
}

# Create CycleCloud server VM
resource "azurerm_virtual_machine" "microhack_cc_vm" {
  name                              = var.cyclecloud_server_name
  location                          = azurerm_resource_group.microhack_rg.location 
  resource_group_name               = azurerm_resource_group.microhack_rg.name
  network_interface_ids             = [azurerm_network_interface.microhack_cc_nic.id]
  vm_size                           = var.machine_type
  delete_os_disk_on_termination     = true
  delete_data_disks_on_termination  = true

  identity {
    type = "SystemAssigned"
  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.cyclecloud_server_name}-osdisk"
    disk_size_gb      = "128"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.cyclecloud_server_name
    admin_username = var.admin_username
    custom_data    = base64encode( <<CUSTOM_DATA
#cloud-config
#
# installs CycleCloud on the VM
#
yum_repos:
  azure-cli:
    baseurl: https://packages.microsoft.com/yumrepos/azure-cli
    enabled: true
    gpgcheck: true
    gpgkey: https://packages.microsoft.com/keys/microsoft.asc
    name: Azure CLI
  cyclecloud:
    baseurl: https://packages.microsoft.com/yumrepos/cyclecloud
    enabled: true
    gpgcheck: true
    gpgkey: https://packages.microsoft.com/keys/microsoft.asc
    name: Cycle Cloud
packages:
- java-1.8.0-openjdk-headless
- azure-cli
- cyclecloud8
write_files:
- content: |
    [{
        "AdType": "Application.Setting",
        "Name": "cycleserver.installation.initial_user",
        "Value": "${var.cyclecloud_username}"
    },
    {
        "AdType": "Application.Setting",
        "Name": "cycleserver.installation.complete",
        "Value": true
    },
    {
        "AdType": "AuthenticatedUser",
        "Name": "${var.cyclecloud_username}",
        "RawPassword": "${var.cyclecloud_password}",
        "Superuser": true
    }] 
  owner: root:root
  path: ./account_data.json
  permissions: '0644'
- content: |
    {
      "Name": "Azure",
      "Environment": "public",
      "AzureRMSubscriptionId": "${data.azurerm_subscription.current.subscription_id}",
      "AzureRMUseManagedIdentity": true,
      "Location": "westeurope",
      "RMStorageAccount": "${azurerm_storage_account.microhack_cc_locker.name}",
      "RMStorageContainer": "cyclecloud"
    }
  owner: root:root
  path: ./azure_data.json
  permissions: '0644'
runcmd:
- sed -i --follow-symlinks "s/webServerMaxHeapSize=.*/webServerMaxHeapSize=4096M/g" /opt/cycle_server/config/cycle_server.properties
- sed -i --follow-symlinks "s/webServerPort=.*/webServerPort=80/g" /opt/cycle_server/config/cycle_server.properties
- sed -i --follow-symlinks "s/webServerSslPort=.*/webServerSslPort=443/g" /opt/cycle_server/config/cycle_server.properties
- sed -i --follow-symlinks "s/webServerEnableHttps=.*/webServerEnableHttps=true/g" /opt/cycle_server/config/cycle_server.properties
- systemctl restart cycle_server
- /opt/cycle_server/cycle_server await_startup
- mv ./account_data.json /opt/cycle_server/config/data/
- /opt/cycle_server/cycle_server execute "update Application.Setting set Value = false where name == \"authorization.check_datastore_permissions\""
- unzip /opt/cycle_server/tools/cyclecloud-cli.zip
- ./cyclecloud-cli-installer/install.sh --system
- sleep 60
- /usr/local/bin/cyclecloud initialize --batch --url=https://localhost --verify-ssl=false --username="${var.cyclecloud_username}" --password="${var.cyclecloud_password}"
- /usr/local/bin/cyclecloud account create -f ./azure_data.json
  CUSTOM_DATA
  )
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = var.admin_key_data
    }
  }
}

# Assign role to the managed ID
resource "azurerm_role_assignment" "microhack_cc_mi_role" {
  scope                 = data.azurerm_subscription.current.id
  role_definition_name  = "Contributor"
  principal_id          = lookup(azurerm_virtual_machine.microhack_cc_vm.identity[0], "principal_id")
}

# Data public IP address
data "azurerm_public_ip" "cc_vm" {
  name                = azurerm_public_ip.microhack_cc_public_ip.name
  resource_group_name = azurerm_public_ip.microhack_cc_public_ip.resource_group_name
  depends_on          = [azurerm_virtual_machine.microhack_cc_vm]  
}

# Output public IP address
output "cyclecloud_server_public_ip" {
  value = data.azurerm_public_ip.cc_vm.ip_address
}
