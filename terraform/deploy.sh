# Install Terraform on your PC or use Cloud Shell

sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform_0.11.7_linux_amd64.zip
sudo mv ./terraform /usr/bin

# Download modules

terraform get
terraform init

# Show Terraform deployment plan

terraform plan

# Deploy environment

terraform apply

# Destroy environment

terraform destroy