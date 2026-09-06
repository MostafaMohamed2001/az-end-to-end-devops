variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key_path" {
  type = string
}

variable "admin_ip" {
  type = string
}

variable "apex_tags" {
  type = map(string)
}