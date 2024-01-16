variable "hcloud_token" {
  sensitive = true
  default = "l4UcI5BlyaIyZF7D8lzbvaGdHpVubiXEEpWujM4TIF5S3npsM5dSyMWfNqBIIQzO"
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