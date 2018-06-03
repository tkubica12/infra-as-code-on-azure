variable "standardtiersize" {
  default = "S0"
}

variable "group_name" {}

# Resource group for database
resource "azurerm_resource_group" "db" {
  name     = "${var.group_name}"
  location = "West Europe"
}

# Random generator
resource "random_id" "dbserver" {
  byte_length = 4
}
resource "random_id" "db" {
  byte_length = 4
}

# Azure Database Server
resource "azurerm_sql_server" "db" {
  name                         = "sql-${random_id.dbserver.hex}"
  resource_group_name          = "${azurerm_resource_group.db.name}"
  location                     = "West Europe"
  version                      = "12.0"
  administrator_login          = "myadmin"
  administrator_login_password = "Password1234!"
}

# Azure Database
resource "azurerm_sql_database" "db" {
  name                             = "sqldb-${random_id.db.hex}"
  resource_group_name              = "${azurerm_resource_group.db.name}"
  location                         = "West Europe"
  server_name                      = "${azurerm_sql_server.db.name}"
  requested_service_objective_name = "${var.standardtiersize}"
  edition                          = "Standard"
}
