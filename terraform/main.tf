data "azurerm_client_config" "current" {}


module "resource-group" {
  source = "./modules/resource-group"

  resource_group_name = var.resource_group_name
  location            = var.location
  apex_tags           = var.apex_tags
}


module "network" {
  source = "./modules/network"

  resource_group_name = module.resource-group.resource_group_name
  location            = module.resource-group.location

  vnet_name     = "apex-dev-vnet"
  address_space = ["10.0.0.0/16"]

  apex_tags = var.apex_tags
}


module "container_registry" {
  source = "./modules/acr"

  resource_group_name = module.resource-group.resource_group_name
  location            = module.resource-group.location

  apex_tags = var.apex_tags
}


module "aks" {
  source = "./modules/aks"

  cluster_name = "apex-aks"

  resource_group_name = module.resource-group.resource_group_name
  location            = module.resource-group.location

  dns_prefix = "apex"

  subnet_id = module.network.subnet_1_id

  system_node_vm_size = "Standard_EC2as_v5"

  apex_tags = var.apex_tags
}


resource "azurerm_role_assignment" "acr_pull" {
  scope                = module.container_registry.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id
}


module "dns" {
  source = "./modules/dns"

  resource_group_name = module.resource-group.resource_group_name

  vnet_id = module.network.vnet_id

  apex_tags = var.apex_tags
}


module "postgresql" {
  source = "./modules/postgresql"

  postgres_name = "apex-postgres"

  resource_group_name = module.resource-group.resource_group_name
  location            = module.resource-group.location

  postgres_subnet_id = module.network.postgres_subnet_id

  private_dns_zone_id = module.dns.private_dns_zone_id

  admin_username = var.postgres_admin_username
  admin_password = var.postgres_admin_password

  apex_tags = var.apex_tags
}


module "keyvault" {
  source = "./modules/keyvault"

  key_vault_name = "apex-keyvault-2026"

  resource_group_name = module.resource-group.resource_group_name
  location            = module.resource-group.location

  tenant_id = data.azurerm_client_config.current.tenant_id

  terraform_principal_id = data.azurerm_client_config.current.object_id

  postgres_admin_username = var.postgres_admin_username
  postgres_admin_password = var.postgres_admin_password

  apex_tags = var.apex_tags
}


module "jenkins" {
  source = "./modules/jenkins"

  resource_group_name = module.resource-group.resource_group_name
  location            = module.resource-group.location

  subnet_id = module.network.subnet_2_id

  admin_username      = "azureuser"
  ssh_public_key_path = "~/.ssh/apex_jenkins.pub"

  admin_ip = var.admin_ip

  apex_tags = var.apex_tags
}