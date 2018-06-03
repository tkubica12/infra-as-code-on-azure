# Resource group for shared services
resource "azurerm_resource_group" "sharedservices" {
  name     = "t-sharedservices"
  location = "West Europe"
}

# Virtual network
resource "azurerm_virtual_network" "network" {
  name                = "myProductionNet"
  address_space       = ["10.0.0.0/16"]
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.sharedservices.name}"
}

resource "azurerm_subnet" "websubnet" {
  name                 = "websubnet"
  resource_group_name  = "${azurerm_resource_group.sharedservices.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "testsubnet" {
  name                 = "testsubnet"
  resource_group_name  = "${azurerm_resource_group.sharedservices.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.3.0/24"
}

output "websubnet" {
  value = "${azurerm_subnet.websubnet.id}"
}

output "testsubnet" {
  value = "${azurerm_subnet.testsubnet.id}"
}

