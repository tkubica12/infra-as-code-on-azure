# Terraform with Azure demo

Terraform is universal infrastructure as code open source tool developed by Hashicorp. It is very declarative with easy to read language structure and fully desired state including lifecycle management (provisioning, rolling out changes, destroying). Terraform supports all major cloud providers including Azure and can provide level of abstraction and reusability with multiple environments as opposed to vendor specific solutions (Azure ARM, AWS CloudFormation).

Terraform provides paid version (Enterprise) on top of this open source project that adds central state management, roles and collaboration, enterprise integration, version control integration and GUI.

## Install Terraform

```
sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/0.10.0/terraform_0.10.0_linux_amd64.zip
unzip terraform_0.10.0_linux_amd64.zip
sudo mv ./terraform /usr/bin
```

## Use
Jump into directory

Create configuration file with Azure access details (service principal access, note that client id = app id and tenant id = directory id) terraform.tfvars:

```
subscription_id = "xxx"
client_id       = "xxx"
client_secret   = "xxx"
tenant_id       = "xxx"
```

When running Terraform for first time make it load all our modules.

```
terraform get
```

Execute

```
terraform plan
terraform apply
terraform destroy
```

## What it does
This example shows complex terraform infrastructure with reusable modules. main.tf contains main declarative state infrastructure with some inputs. Modules are used to create reusable infrastructure as code and setup production and test environment. Shared services module creates network. Web module creates couple of VMs and load balancer. App module creates container registry and Kubernetes cluster. Database module prepares Azure SQL DB.



Tomas Kubica

Find me on linkedin.com/in/tkubica