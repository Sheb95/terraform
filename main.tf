terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }


}

resource "azurerm_resource_group" "rg_name" {
  name     = var.resource_group_name
  location = "ukwest"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myFirstVnet"
  address_space       = ["10.0.0.0/11"]
  location            = "ukwest"
  resource_group_name = azurerm_resource_group.rg_name.name
}

resource "azurerm_subnet" "my_subnet"{
  name = "subnet-1"
  resource_group_name = azurerm_resource_group.rg_name.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.0.0/12"]
}

resource "azurerm_network_interface" "nic"{
  name = "sheb-nic"
  location = azurerm_resource_group.rg_name.location
  resource_group_name = azurerm_resource_group.rg_name.name

  ip_configuration {
    name = "subnet-1"
    subnet_id = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_linux_virtual_machine" "linux_VM" {
  name                = "my-machine"
  resource_group_name = azurerm_resource_group.rg_name.name
  location            = azurerm_resource_group.rg_name.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = "P@ssword3!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}









