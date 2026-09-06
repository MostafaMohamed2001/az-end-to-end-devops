resource "azurerm_private_dns_zone" "private_postgres_dns" {
  name                = "apex.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.apex_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_vnet_link" {
  name                  = "apex-postgres-vnet-link"
  private_dns_zone_id   = azurerm_private_dns_zone.private_postgres_dns.id
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}