variable "nodes" {
  default = 3
}

variable "subnet" {}
variable "group_name" {}

# Resource group for web layer
resource "azurerm_resource_group" "web" {
  name     = "${var.group_name}"
  location = "West Europe"
}

# Web layer NIC
resource "azurerm_network_interface" "web" {
  name                = "webnic${count.index}"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.web.name}"
  count               = "${var.nodes}"

  ip_configuration {
    name                          = "myIPconfiguration"
    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "dynamic"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.web.id}"]
  }
}

# Web Availability Set
resource "azurerm_availability_set" "web" {
  name                = "webAS"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.web.name}"
  managed             = true
}

# Web servers
resource "azurerm_virtual_machine" "web" {
  name                             = "webvm${count.index}"
  location                         = "West Europe"
  resource_group_name              = "${azurerm_resource_group.web.name}"
  network_interface_ids            = ["${element(azurerm_network_interface.web.*.id, count.index)}"]
  vm_size                          = "Standard_B1s"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  count                            = "${var.nodes}"
  availability_set_id              = "${azurerm_availability_set.web.id}"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "webosdisk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "webdatadisk${count.index}"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "32"
  }

  os_profile {
    computer_name  = "webvm${count.index}"
    admin_username = "myadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Web LB public IP
resource "azurerm_public_ip" "weblb" {
  name                         = "weblbip"
  location                     = "West Europe"
  resource_group_name          = "${azurerm_resource_group.web.name}"
  public_ip_address_allocation = "static"
}

# Web LB
resource "azurerm_lb" "web" {
  name                = "weblb"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.web.name}"

  frontend_ip_configuration {
    name                 = "LBPublicIP"
    public_ip_address_id = "${azurerm_public_ip.weblb.id}"
  }
}

# Web LB backend pool
resource "azurerm_lb_backend_address_pool" "web" {
  resource_group_name = "${azurerm_resource_group.web.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
  name                = "BackEndAddressPool"
}

# Web LB probe
resource "azurerm_lb_probe" "web" {
  resource_group_name = "${azurerm_resource_group.web.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
  name                = "web-probe"
  protocol            = "Http"
  request_path        = "/"
  port                = 80
}

# Web LB rule
resource "azurerm_lb_rule" "test" {
  resource_group_name            = "${azurerm_resource_group.web.name}"
  loadbalancer_id                = "${azurerm_lb.web.id}"
  name                           = "WebRule"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LBPublicIP"
}