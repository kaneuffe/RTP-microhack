resource "azurerm_netapp_account" "microhack_anf_acc" {
  name                = "${var.prefix}-anf-account"
  location            = azurerm_resource_group.microhack_rg.location
  resource_group_name = azurerm_resource_group.microhack_rg.name
}

resource "azurerm_netapp_pool" "microhack_anf_pool" {
  name                = "${var.prefix}-anf-pool"
  account_name        = azurerm_netapp_account.microhack_anf_acc.name
  location            = azurerm_resource_group.microhack_rg.location
  resource_group_name = azurerm_resource_group.microhack_rg.name
  service_level       = "Standard"
  size_in_tb          = 4
}

resource "azurerm_netapp_volume" "microhack_anf_volume" {
  count                = var.nteams
  #lifecycle {
  #  prevent_destroy = true
  #}
  name                = "${var.prefix}-anf-${count.index}-volume"
  location            = azurerm_resource_group.microhack_rg.location
  resource_group_name = azurerm_resource_group.microhack_rg.name
  account_name        = azurerm_netapp_account.microhack_anf_acc.name
  pool_name           = azurerm_netapp_pool.microhack_anf_pool.name  
  volume_path         = "my-unique-file-path"
  service_level       = "Premium"
  subnet_id           = azurerm_subnet.microhack_anf_subnet.id
  protocols           = ["NFSv4.1"]
  storage_quota_in_gb = 500
}

data "azurerm_netapp_volume" "anf_volume" {
  count               = var.nteams
  resource_group_name = azurerm_resource_group.microhack_rg.name
  account_name        = azurerm_netapp_account.microhack_anf_acc.name
  pool_name           = azurerm_netapp_pool.microhack_anf_pool.name
  name                = azurerm_netapp_volume.miocrohack_anf_volume[count.index].name
  depends_on          = [azurerm_netapp_volume.microhack_anf_volume]
}

output "anf_mountpoint_ips" {
  value = data.azurerm_netapp_volume.anf_volume.*.mount_ip_addresses
} 