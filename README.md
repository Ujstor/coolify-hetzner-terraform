# Self hosted Coolify instance on Hetzner with Terraform

Deploy [Coolify](https://coolify.io/docs/) on Hetzner Cloud using the Terraform. This project aims to create a highly optimized, auto-upgradable, highly available and cost-effective self hosted Coolify instance for deployng your projects on Hetzner Cloud.

## Prerequisites

Before you begin, ensure you have the following:

- A Hetzner Cloud account. You can sign up for one [here](https://hetzner.cloud/?ref=Ix9xCKNxJriM) (free €⁠20 in cloud credits for new users).
- The following command-line tools installed:
  - [Terraform](https://www.terraform.io/downloads.html)
  - [hcloud CLI](https://github.com/hetznercloud/cli)

### Install prerequisites

- Install Terraform:

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

- Install hcloud CLI:

```bash
go install github.com/hetznercloud/cli/cmd/hcloud@latest
```

## Deployment Steps

### 1. Generate SSH Keys

Generate a passphrase-less SSH key pair to be used for the cluster. Make note of the paths to your private and public keys.

```shell
ssh-keygen -t ed25519 -N "coolify-hetzner" -f ~/.ssh/coolify-hetzner
```

### 2. Generate Hetzner API Token

Create new project in Hetzner console https://console.hetzner.cloud/projects 

Obtain API token from Hetzner console that will be used by Terraform to interact with the platform. 
Navigate to your project and click on SECURITY > API TOKENS > GENERATE API

Provide a name, permission, generate token and past it in the `hcloud_token` variable in `variables.tf`.





### 4. Initialize and Apply Terraform

Now that you have your `kube.tf` file ready, initialize Terraform and apply the configuration:

```shell
cd <your-project-folder>
terraform init --upgrade
terraform validate
terraform apply -auto-approve
```

### 5. List images and servers types

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
```

