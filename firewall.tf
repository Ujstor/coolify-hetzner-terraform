resource "hcloud_firewall" "default" {
  labels = {}
  name   = "firewall-1"

  rule {
    destination_ips = []
    direction       = "in"
    port            = "22"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    destination_ips = []
    direction       = "in"
    port            = "80"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    destination_ips = ["0.0.0.0/0"]
    direction       = "out"
    port            = "80"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    destination_ips = []
    direction       = "in"
    port            = "443"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    destination_ips = ["0.0.0.0/0"]
    direction       = "out"
    port            = "443"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    destination_ips = []
    direction       = "in"
    port            = "6001"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    destination_ips = ["0.0.0.0/0"]
    direction       = "out"
    port            = "6001"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }


  rule {
    destination_ips = []
    direction       = "in"
    port            = "8000"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    destination_ips = []
    direction       = "in"
    port            = "3000"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

rule {
    destination_ips = []
    direction       = "in"
    port            = "9000-9100"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    destination_ips = ["0.0.0.0/0"]
    direction       = "out"
    port            = "9000-9100"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }


}
