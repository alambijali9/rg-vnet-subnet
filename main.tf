resource "azurerm_resource_group" "rg" {
  name     = "rg-test"
  location = "centralindia"
}



resource "azurerm_virtual_network" "net" {
  name                = "vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]


  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"

  }

  subnet {
    name           = "jump-subnet"
    address_prefix = "10.0.3.0/24"

  }

}