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
  name        = "coolify_key"
  public_key  = tls_private_key.ssh_key.public_key_openssh
}

resource "hcloud_server" "coolify" {
  count        = var.instances
  name         = "coolify-${count.index}"
  image        = var.os_type
  server_type  = var.server_type
  location     = var.location
  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.default.id]
  user_data    = file("server-config.sh")
  labels = {
    type = "coolify"
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "${tls_private_key.ssh_key.private_key_pem}" > ~/.ssh/coolify_key.pem &&
      chmod 600 ~/.ssh/coolify_key.pem
    EOT
  }
}


output "server_ip" {
  value = [for instance in hcloud_server.coolify : instance.ipv4_address]
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}
