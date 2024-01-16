#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Exiting..."
  exit 1
fi

apt-get update
apt-get upgrade -y
apt-get install -y ufw fail2ban

# Configure ufw rules
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 8000
ufw allow 3000
ufw allow 6001
ufw allow 9000:9100/tcp
ufw --force enable

# Configure fail2ban
printf "[sshd]\nenabled = true\nbanaction = iptables-multiport" > /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl start fail2ban

# SSH Hardening for root user
sed -i '/^PermitRootLogin/s/^.*$/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i '/^PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i '/^X11Forwarding/s/^.*$/X11Forwarding no/' /etc/ssh/sshd_config
sed -i '/^#MaxAuthTries/s/^.*$/MaxAuthTries 2/' /etc/ssh/sshd_config
sed -i '/^#AllowTcpForwarding/s/^.*$/AllowTcpForwarding no/' /etc/ssh/sshd_config
sed -i '/^#AllowAgentForwarding/s/^.*$/AllowAgentForwarding no/' /etc/ssh/sshd_config
sed -i '/^#AuthorizedKeysFile/s/^.*$/AuthorizedKeysFile .ssh/authorized_keys/' /etc/ssh/sshd_config
sed -i '$a AllowUsers root' /etc/ssh/sshd_config

systemctl restart ssh

# Install coolify
#ver.3
curl -fsSL https://get.coollabs.io/coolify/install.sh -o install.sh && sudo bash ./install.sh -f

#ver.4
#curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
