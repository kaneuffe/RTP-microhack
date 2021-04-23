resource "azurerm_container_registry" "microhack-acr" {
  name                = "${var.prefix}acr21"
  location            = azurerm_resource_group.microhack_rg.location
  resource_group_name = azurerm_resource_group.microhack_rg.name
  sku                      = "Basic"
  admin_enabled            = true
}