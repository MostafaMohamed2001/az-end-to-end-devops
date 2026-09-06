

resource "azurerm_container_registry" "acr" {
  name                = "apexregistry001"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.apex_tags
  #   georeplications {
  #     location                        = "East US"
  #     global_endpoint_routing_enabled = true
  #     zone_redundancy_enabled         = true
  #     tags                            = {}
  #   }
  #   georeplications {
  #     location                        = "North Europe"
  #     global_endpoint_routing_enabled = true
  #     zone_redundancy_enabled         = true
  #     tags                            = {}
  #   }
}
