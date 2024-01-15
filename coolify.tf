terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = ">=1.36.0"
    }
  }
}

provider "hcloud" {
  token   = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "hetzner_key"
  public_key = file("~/.ssh/coolify-hetzner.pub")
}

resource "hcloud_server" "coolfy" {
  count       = var.instances
  name        = "coolfy-server-${count.index}"
  image       = var.os_type
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
  labels = {
    type = "coolfy"
  }
  user_data = file("server-config.yaml")
}
