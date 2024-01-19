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

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "default" {
  depends_on  = [tls_private_key.ssh_key]
  name        = "coolfy_key"
  public_key  = tls_private_key.ssh_key.public_key_openssh
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

  provisioner "local-exec" {
    command = <<-EOT
      echo "${tls_private_key.ssh_key.private_key_pem}" > ~/.ssh/coolfy_key.pem &&
      chmod 600 ~/.ssh/coolfy_key.pem
    EOT
  }
}


output "server_ip" {
  value = [for instance in hcloud_server.coolfy : instance.ipv4_address]
}

output "private_key" {
  value = tls_private_key.ssh_key.private_key_pem
  sensitive=true
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}
