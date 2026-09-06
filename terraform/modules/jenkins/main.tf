resource "azurerm_public_ip" "jenkins_public_ip" {
  name                = "jenkins-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.apex_tags
}


resource "azurerm_network_interface" "jenkins_nic" {
  name                = "jenkins-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "jenkins-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.jenkins_public_ip.id
  }

  tags = var.apex_tags
}


resource "azurerm_network_security_group" "jenkins_nsg" {
  name                = "jenkins-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.admin_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Jenkins"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = var.admin_ip
    destination_address_prefix = "*"
  }

  tags = var.apex_tags
}


resource "azurerm_network_interface_security_group_association" "jenkins_nsg_association" {
  network_interface_id      = azurerm_network_interface.jenkins_nic.id
  network_security_group_id = azurerm_network_security_group.jenkins_nsg.id
}


resource "azurerm_linux_virtual_machine" "jenkins" {
  name                = "apex-jenkins"
  resource_group_name = var.resource_group_name
  location            = var.location

  size           = "Standard_B2s"
  zone           = "1"
  admin_username = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.jenkins_nic.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 32
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = var.apex_tags
}
