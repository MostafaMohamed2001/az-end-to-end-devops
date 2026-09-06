resource "azurerm_postgresql_flexible_server" "postgres" {
  name                = var.postgres_name
  resource_group_name = var.resource_group_name
  location            = var.location

  version = "16"

  delegated_subnet_id = var.postgres_subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  public_network_access_enabled = false

  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768

  backup_retention_days = 7

  tags = var.apex_tags

  lifecycle {
    ignore_changes = [
      zone
    ]
  }
}