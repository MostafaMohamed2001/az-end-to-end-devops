resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  role_based_access_control_enabled = true
  local_account_disabled            = false

  node_provisioning_profile {
    mode = "Manual"
  }
  default_node_pool {
    name                   = "system"
    vm_size                = var.system_node_vm_size
    vnet_subnet_id         = var.subnet_id
    node_public_ip_enabled = false

    auto_scaling_enabled = false
    # min_count            = 1
    # max_count            = 3
    node_count      = 1
    os_disk_size_gb = 64
    type            = "VirtualMachineScaleSets"
    upgrade_settings {
    max_surge                     = "10%"
    drain_timeout_in_minutes      = 0
    node_soak_duration_in_minutes = 0
  }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    load_balancer_sku   = "standard"
    outbound_type       = "loadBalancer"

    service_cidr   = "10.20.0.0/16"
    dns_service_ip = "10.20.0.10"
  }


  tags = var.apex_tags
}
