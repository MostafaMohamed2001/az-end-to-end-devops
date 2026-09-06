variable "key_vault_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "postgres_admin_username" {
  type = string
}

variable "postgres_admin_password" {
  type      = string
  sensitive = true
}

variable "apex_tags" {
  type = map(string)
}


variable "terraform_principal_id" {
  type = string
}