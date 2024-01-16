variable "hcloud_token" {
  sensitive = true
  default = "API_KEY"
}

variable "location" {
  default = "fsn1"
}

variable "instances" {
  default = "1"
}

variable "server_type" {
  default = "cx21"
}

variable "os_type" {
  default = "debian-12"
}