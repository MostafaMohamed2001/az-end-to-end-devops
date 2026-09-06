resource "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tenant_id = var.tenant_id
  sku_name  = "standard"

  rbac_authorization_enabled = true

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = var.apex_tags
}


resource "azurerm_role_assignment" "terraform_keyvault_secrets" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.terraform_principal_id
}


resource "azurerm_key_vault_secret" "postgres_username" {
  name         = "postgres-username"
  value        = var.postgres_admin_username
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_role_assignment.terraform_keyvault_secrets
  ]
}


resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgres-password"
  value        = var.postgres_admin_password
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_role_assignment.terraform_keyvault_secrets
  ]
}