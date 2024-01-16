#!/bin/bash

PUB_SSH_KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXapWitBo+jzdZwY7Eps5PTFr7enN6QuvPTo4HyZL2L ujstor@ujstor'
USER_PASSWORD='root'

# Add public key for root
echo ${PUB_SSH_KEY} >> /root/.ssh/authorized_keys
echo "root:${USER_PASSWORD}" | chpasswd
chown -R root:root /root/.ssh
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys

# Create user
useradd coolify -m -s /bin/bash
usermod -aG users coolify
usermod -aG admin coolify
echo "coolify:${USER_PASSWORD}" | chpasswd
mkdir -p /home/coolify/.ssh
echo ${PUB_SSH_KEY} > /home/coolify/.ssh/authorized_keys
chown -R coolify:coolify /home/coolify/.ssh
chmod 700 /home/coolify/.ssh
chmod 600 /home/coolify/.ssh/authorized_keys
usermod -aG sudo coolify

# Update & install packages
apt-get update
apt-get upgrade -y
apt-get install -y fail2ban ufw

# Configure ufw rules
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 8000
ufw allow 6001
ufw --force enable

# Configure fail2ban
printf "[sshd]\nenabled = true\nbanaction = iptables-multiport" > /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl start fail2ban

# SSH Hardening
sed -i '/^PermitRootLogin/s/^.*$/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i '/^PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i '/^X11Forwarding/s/^.*$/X11Forwarding no/' /etc/ssh/sshd_config
sed -i '/^#MaxAuthTries/s/^.*$/MaxAuthTries 5/' /etc/ssh/sshd_config
sed -i '/^#AllowTcpForwarding/s/^.*$/AllowTcpForwarding no/' /etc/ssh/sshd_config
sed -i '/^#AllowAgentForwarding/s/^.*$/AllowAgentForwarding no/' /etc/ssh/sshd_config
sed -i '/^#AuthorizedKeysFile/s/^.*$/AuthorizedKeysFile .ssh/authorized_keys/' /etc/ssh/sshd_config
sed -i '$a AllowUsers coolify' /etc/ssh/sshd_config

systemctl restart ssh

# Install coolify
#ver. 4
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

#ver. 3
# wget -q https://get.coollabs.io/coolify/install.sh \
# -O install.sh; sudo bash ./install.sh -f
