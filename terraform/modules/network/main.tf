resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.apex_tags
}


### Subnet 1 ###

resource "azurerm_subnet" "subnet_1" {

  name                 = "subnet-1"
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name

}



### Subnet 2 ###
resource "azurerm_subnet" "subnet_2" {

  name                 = "subnet-2"
  address_prefixes     = ["10.0.2.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name

}



### Subnet Postgress ###


resource "azurerm_subnet" "postgres_subnet" {
  name                 = "postgres-sn"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]

  delegation {
    name = "postgres-flexible-server"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}
### Network Secuirty Group ###
resource "azurerm_network_security_group" "n_sg" {
  name                = "network_security-group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.apex_tags
}
