# Self hosted Coolify instance on Hetzner with Terraform

Deploy [Coolify](https://coolify.io/docs/) on Hetzner Cloud using the Terraform. This project aims to create a highly optimized, auto-upgradable, highly available and cost-effective self hosted Coolify instance for deployng your projects on Hetzner Cloud.

Default configuration will create a one server in Germnay with 2 CPU, 4 GB RAM, 40 GB disk space, 20TB out traffic for 5.77EUR/month. Change configuration to your needs in `variables.tf` file, see [Additional Configuration](#Additional-Configuration).

## Prerequisites

Before you begin, ensure you have the following:

- A Hetzner Cloud account. You can sign up for one [here](https://hetzner.cloud/?ref=Ix9xCKNxJriM) (free €⁠20 in cloud credits for new users)
- [Terraform](https://www.terraform.io/downloads.html) command-line tool installed
 
 Install Terraform:

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

## Deployment Steps

### 1. Generate SSH Keys

Generate a passphrase-less SSH key pair to be used for the cluster.

```shell
ssh-keygen -t ed25519 -N "" -f ~/.ssh/coolify-hetzner
```
Cat pub key and populate `PUB-SSH-KEY=` in `server-config.sh`. In same file add `USER_PASSWORD` for sudo access when you ssh into created server.

```shell
cat ~/.ssh/coolify-hetzner.pub
```

### 2. Generate Hetzner API Token

Create new project in Hetzner console https://console.hetzner.cloud/projects 

Obtain API token from Hetzner console that will be used by Terraform to interact with the platform. 
Navigate to your project and click on SECURITY > API TOKENS > GENERATE API (give read/write access)

Paste API token in the `hcloud_token` variable in `variables.tf`.


### 3. Initialize and Apply Terraform

Initialize Terraform and apply the configuration:

```shell
cd <your-project-folder>
terraform init --upgrade
terraform validate
terraform apply -auto-approve
```

### 4. OPEN UI or SSH into the server

When Terraform finishes, give server a couple of minutes to install all dependencies. Coolify's UI will be available at: 

```shell
SERVER_IP:8000
```

If needed, you can ssh into the server with the following command:

```shell
ssh coolify@<server-ip> -i ~/.ssh/coolify-hetzner.pub
```

### 5. Destroy infrastructure

To destroy the infrastructure run the following command:

```shell
terraform destroy -auto-approve
```

## Aditional Configuration

### 1. Firewall Rules

To make the server access more secure, we created firewall rules that only allow traffic on ports 22, 80, 443, 6001 and 8000

Add more rules in `firewall.tf` file if you use db that you want to access from outside.

```terraform
rule {
    destination_ips = []
    direction       = "in"
    port            = "5432"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }
  rule {
    destination_ips = ["0.0.0.0/0"]
    direction       = "out"
    port            = "5432"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }
```

### 2. List images, servers types and locations

You can check the list of images and servers on official Hetzner Cloud website.
Also, you can  query [REST API](https://docs.hetzner.cloud/#servers-create-a-server) with the same API_TOKEN we created earlier. Then, all our information needs are just a curl away.

```shell
export TF_HETZNER_TOKE= <API_TOKEN>

curl \
 -H "Authorization: Bearer $TF_HETZNER_TOKEN" \
 'https://api.hetzner.cloud/v1/images'

curl \
 -H "Authorization: Bearer $TF_HETZNER_TOKEN" \
 'https://api.hetzner.cloud/v1/server_types'

 curl \
 -H "Authorization: Bearer $TF_HETZNER_TOKEN" \
 'https://api.hetzner.cloud/v1/locations'
```