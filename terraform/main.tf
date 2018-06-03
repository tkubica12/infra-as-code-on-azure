variable "webnodes" {
  default = 3
}
variable "mastercount" {
  default = 1
}
variable "agentcount" {
  default = 3
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Network and other shared services
module "sharedservices" {
  source = "./shared_services"
}

# Production environment
module "web_nodes_production" {
  source     = "./web_nodes"
  nodes      = "${var.webnodes}"
  subnet     = "${module.sharedservices.websubnet}"
  group_name = "t-web-prod"
}

module "app_production" {
  source           = "./app_kubernetes"
  mastercount      = "${var.mastercount}"
  agentcount       = "${var.agentcount}"
  group_name       = "t-app-prod"
  client_id        = "${var.client_id}"
  client_secret    = "${var.client_secret}"
}

module "db_production" {
  source           = "./database"
  standardtiersize = "S1"
  group_name       = "t-db-prod"
}

# Test environment
module "web_nodes_test" {
  source     = "./web_nodes"
  nodes      = "1"
  subnet     = "${module.sharedservices.testsubnet}"
  group_name = "t-web-test"
}

module "app_test" {
  source           = "./app_kubernetes"
  mastercount      = 1
  agentcount       = 1
  group_name       = "t-app-test"
  client_id        = "${var.client_id}"
  client_secret    = "${var.client_secret}"
}

module "db_test" {
  source           = "./database"
  standardtiersize = "S0"
  group_name       = "t-db-test"
}
