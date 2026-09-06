output "jenkins_public_ip" {
  value = azurerm_public_ip.jenkins_public_ip.ip_address
}

output "jenkins_private_ip" {
  value = azurerm_network_interface.jenkins_nic.private_ip_address
}

output "jenkins_identity_principal_id" {
  value = azurerm_linux_virtual_machine.jenkins.identity[0].principal_id
}

output "jenkins_vm_id" {
  value = azurerm_linux_virtual_machine.jenkins.id
}