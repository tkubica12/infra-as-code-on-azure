variable "mastercount" {
  default = 1
}

variable "agentcount" {
  default = 1
}

variable "group_name" {}
variable "client_id" {}
variable "client_secret" {}

# Random generator
resource "random_id" "master" {
  byte_length = 4
}

resource "random_id" "agent" {
  byte_length = 4
}

resource "random_id" "registry" {
  byte_length = 4
}

resource "random_id" "storage" {
  byte_length = 4
}

# Resource group for app layer in Kubernetes
resource "azurerm_resource_group" "app" {
  name     = "${var.group_name}"
  location = "West Europe"
}

# Azure Container Registry
resource "azurerm_container_registry" "app" {
  name                = "contreg${random_id.registry.hex}"
  resource_group_name = "${azurerm_resource_group.app.name}"
  location            = "${azurerm_resource_group.app.location}"
  admin_enabled       = true
  sku                 = "Basic"
}

# Kubernetes cluster
resource "azurerm_kubernetes_cluster" "app" {
  name                = "appkubernetes"
  location            = "${azurerm_resource_group.app.location}"
  resource_group_name = "${azurerm_resource_group.app.name}"
  dns_prefix          = "appkube${random_id.registry.hex}"

  linux_profile {
    admin_username = "myadmin"

    ssh_key {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqaZoyiz1qbdOQ8xEf6uEu1cCwYowo5FHtsBhqLoDnnp7KUTEBN+L2NxRIfQ781rxV6Iq5jSav6b2Q8z5KiseOlvKA/RF2wqU0UPYqQviQhLmW6THTpmrv/YkUCuzxDpsH7DUDhZcwySLKVVe0Qm3+5N2Ta6UYH3lsDf9R9wTP2K/+vAnflKebuypNlmocIvakFWoZda18FOmsOoIVXQ8HWFNCuw9ZCunMSN62QGamCe3dL5cXlkgHYv7ekJE15IA9aOJcM7e90oeTqo+7HTcWfdu0qQqPWY5ujyMw/llas8tsXY85LFqRnr3gJ02bAscjc477+X+j/gkpFoN1QEmt terraform@demo.tld"
    }
  }

  agent_pool_profile {
    name    = "default"
    count   = "${var.agentcount}"
    vm_size = "Standard_B2s"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }
}
