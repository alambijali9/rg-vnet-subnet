resource "azurerm_resource_group" "rg" {
  name     = "rg-test"
  location = "southindia"
}



resource "azurerm_virtual_network" "net" {
  name                = "vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "sub" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.net.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "p-ip" {

  name                = "pip-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"



  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "NIC" {
  name                = "NIC"
  location            = "southindia"
  resource_group_name = "rg-test"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.p-ip.id

  }
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "Docker"
  resource_group_name             = "rg-test"
  location                        = "southindia"
  size                            = "Standard_F2"
  admin_username                  = "devopsinsider"
  admin_password                  = "test@1234567"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.NIC.id
  ]



  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "30"
    name                 = "Backend-disk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}