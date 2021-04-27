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
  service_level       = "Ultra"
  size_in_tb          = 4
}

resource "azurerm_netapp_volume" "microhack_anf_volume" {
  count                = var.nteams
  #lifecycle {
  #  prevent_destroy = true
  #}
  name                = "${var.prefix}-anf-${count.index + 1}-volume"
  location            = azurerm_resource_group.microhack_rg.location
  resource_group_name = azurerm_resource_group.microhack_rg.name
  account_name        = azurerm_netapp_account.microhack_anf_acc.name
  pool_name           = azurerm_netapp_pool.microhack_anf_pool.name  
  volume_path         = "shared-${count.index + 1}"
  service_level       = "Ultra"
  subnet_id           = azurerm_subnet.microhack_anf_subnet.id
  protocols           = ["NFSv3"]
  storage_quota_in_gb = 650
  depends_on          = [azurerm_netapp_pool.microhack_anf_pool]

  export_policy_rule {
    rule_index      = "1"
    protocols_enabled = ["NFSv3"]
    unix_read_write  = true
    unix_allow_root_access = true
    allowed_clients = ["10.0.${count.index + 2}.0/24"]
  }
}

data "azurerm_netapp_volume" "anf_volume" {
  count               = var.nteams
  resource_group_name = azurerm_resource_group.microhack_rg.name
  account_name        = azurerm_netapp_account.microhack_anf_acc.name
  pool_name           = azurerm_netapp_pool.microhack_anf_pool.name
  name                = azurerm_netapp_volume.microhack_anf_volume[count.index].name
  depends_on          = [azurerm_netapp_volume.microhack_anf_volume]
}

output "anf_mount_ip_addresses" {
  # value = zipmap([for_each value in data.azurerm_netapp_volume.anf_volume: value.mount_ip_addresses], [for_each value in data.azurerm_netapp_volume.anf_volume: value.name])
  value       = data.azurerm_netapp_volume.anf_volume[0].mount_ip_addresses
  description = "Azure NetApp Files IP address"
}

output "anf_volume_path" {
  value = {
    for volume in azurerm_netapp_volume.microhack_anf_volume:
      volume.name => volume.volume_path
  }
}