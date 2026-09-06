


## General Vars ##

variable "apex_tags" {
  type = map(string)
}


variable "resource_group_name" {
  type = string
}




variable "location" {
  type = string
}

variable "postgres_admin_username" {
  type = string
}
variable "postgres_admin_password" {
  type      = string
  sensitive = true

}


variable "admin_ip" {
  type        = string
  description = "My public IP allowed to access Jenkins and SSH"
}