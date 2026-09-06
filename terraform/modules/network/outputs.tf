
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}


output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}



output "subnet_1_id" {
  value = azurerm_subnet.subnet_1.id
}

output "subnet_2_id" {
  value = azurerm_subnet.subnet_2.id
}


output "postgres_subnet_id" {
  value = azurerm_subnet.postgres_subnet.id
}