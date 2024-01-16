terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = ">=1.36.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "hetzner_key"
  public_key = file("~/.ssh/coolify-hetzner.pub")
}

resource "hcloud_server" "coolfy" {
  count        = var.instances
  name         = "coolfy-${count.index}"
  image        = var.os_type
  server_type  = var.server_type
  location     = var.location
  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.default.id]
  user_data    = file("server-config.sh")
  labels = {
    type = "coolfy"
  }
}

output "server_ip" {
  value = [for instance in hcloud_server.coolfy : instance.ipv4_address]
}
