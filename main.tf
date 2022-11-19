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
  features {}
}

resource "azurerm_resource_group" "rg_name" {
  name     = "sheb"
  location = "ukwest"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myFirstVnet"
  address_space       = ["10.0.0.0/11"]
  location            = "ukwest"
  resource_group_name = azurerm_resource_group.rg_name.name
}