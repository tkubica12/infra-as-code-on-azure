# Option 1: Install Terraform on your PC (there is Linux and Windows version)

sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform_0.11.7_linux_amd64.zip
sudo mv ./terraform /usr/bin

# Option 2: Terraform is preinstalled in Azure Cloud Shell

# Option 3: Use jump server created in cloud-init demo

# Copy or edit tfvars with Azure credentials
scp ~/terraform.tfvars tomas@104.214.231.71:~/infra-as-code-on-azure/terraform/

# Download modules

terraform get
terraform init

# Show Terraform deployment plan

terraform plan

# Deploy environment

terraform apply

# Destroy environment

terraform destroy