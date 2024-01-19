variable "hcloud_token" {
  type = string
  description = "Hetzner Cloud API token"
  sensitive = true
  default = "<API_TOKEN>"
}

variable "location" {
  type = string
  description = "Location to create the server's in"
  default = "fsn1"
}

variable "instances" {
  type = string
  description = "Number of instances to create"
  default = "1"
}

variable "server_type" {
  type = string
  description = "Server type to use for the server"
  default = "cx21"
}

variable "os_type" {
  type = string
  description = "OS image to use for the server"
  default = "debian-12"
}