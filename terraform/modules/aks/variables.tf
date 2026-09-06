variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "system_node_vm_size" {
  type    = string
  default = "Standard_D2s_v5"
}

variable "apex_tags" {
  type    = map(string)
  default = {}
}