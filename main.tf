# We strongly recommend using the required_providers block to set the    
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.75.0"
    }
  }
}

provider "azurerm" {
  features {}

  # More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

data "azurerm_resource_group" "hcmxexample" {
  name     = var.resource_group_name
}

resource "azurerm_public_ip" "hcmxexample" {
  name                = var.vm_name
  resource_group_name = data.azurerm_resource_group.hcmxexample.name
  location            = var.location
  allocation_method   = "Dynamic"
  domain_name_label   = var.vm_name
  tags = {
    environment = var.tag
  }
}

data "azurerm_network_security_group" "hcmxexample" {
  name                = var.network_security_group
  #location            = var.location
  resource_group_name = data.azurerm_resource_group.hcmxexample.name
  }
  
  #resource "azurerm_network_security_rule" "hcmxexample" {
  #name                        = "ssh"
  #priority                    = 100
  #direction                   = "Inbound"
  #access                      = "Allow"
  #protocol                    = "Tcp"
  #source_port_range           = "*"
  #destination_port_range      = "22"
  #source_address_prefix       = "*"
  #destination_address_prefix  = "*"
  #resource_group_name         = data.azurerm_resource_group.hcmxexample.name
  #network_security_group_name = azurerm_network_security_group.hcmxexample.name
#}

# resource "azurerm_network_ddos_protection_plan" "hcmxexample" {
# name                = var.name
# location            = var.location
# resource_group_name = azurerm_resource_group.hcmxexample.name
# }

data "azurerm_virtual_network" "hcmxexample" {
  name                = var.virtual_network
  #location            = data.azurerm_network_security_group.hcmxexample.location
  resource_group_name = data.azurerm_resource_group.hcmxexample.name
 # address_space       = ["10.0.0.0/16"]

  # ddos_protection_plan {
  #  id     = azurerm_network_ddos_protection_plan.hcmxexample.id
  #  enable = true
  #}

}

data "azurerm_subnet" "hcmxexample" {
  name                 = var.subnet
  resource_group_name  = data.azurerm_resource_group.hcmxexample.name
  virtual_network_name = data.azurerm_virtual_network.hcmxexample.name
  #address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "hcmxexample" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.hcmxexample.name

  ip_configuration {
    name                          = var.vm_name
    subnet_id                     = data.azurerm_subnet.hcmxexample.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hcmxexample.id
                 }
  }


#resource "azurerm_private_dns_zone" "hcmxexample" {
#  name                = "hcmxexample.com"
#  resource_group_name = data.azurerm_resource_group.hcmxexample.name
#}
  
 resource "azurerm_linux_virtual_machine" "hcmxexample" {
  count = var.os_type=="linux" ? 1 : 0
  name                = var.vm_name
  resource_group_name = data.azurerm_resource_group.hcmxexample.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.vm_username
  admin_password      = var.vm_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.hcmxexample.id,
  ]
  tags = {
    environment = var.tag
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.type_of_storage
  }
   
  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.os_version
  }
}

resource "azurerm_windows_virtual_machine" "hcmxexample" {
  count = var.os_type=="windows" ? 1 : 0
  name                = var.vm_name
  resource_group_name = data.azurerm_resource_group.hcmxexample.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.vm_username
  admin_password      = var.vm_password
  network_interface_ids = [
    azurerm_network_interface.hcmxexample.id,
  ]
  tags = {
    environment = var.tag
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.type_of_storage
  }
   
  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.os_version
  }
}

resource "azurerm_managed_disk" "hcmxexample" {
  name                 = "${var.vm_name}-disk"
  location             = var.location
  #resource_group_name  = var.os_type=="linux" ? azurerm_linux_virtual_machine.hcmxexample[0].name : azurerm_windows_virtual_machine.hcmxexample[0].name
  resource_group_name = data.azurerm_resource_group.hcmxexample.name
  storage_account_type = var.type_of_storage
  create_option        = "Empty"
  disk_size_gb         = var.disk_size
}

resource "azurerm_virtual_machine_data_disk_attachment" "hcmxexample" {
  managed_disk_id    = azurerm_managed_disk.hcmxexample.id
  virtual_machine_id = var.os_type=="linux" ? azurerm_linux_virtual_machine.hcmxexample[0].id : azurerm_windows_virtual_machine.hcmxexample[0].id
  lun                = "10"
  caching            = "ReadWrite"
}

data "azurerm_public_ip" "hcmxexample" {
  name                = var.vm_name
  resource_group_name = var.os_type=="linux" ? azurerm_linux_virtual_machine.hcmxexample[0].resource_group_name : azurerm_windows_virtual_machine.hcmxexample[0].resource_group_name
 #resource_group_name = data.azurerm_resource_group.hcmxexample.name
}

output "public_ip_address" {
  value = data.azurerm_public_ip.hcmxexample.ip_address
}

data "azurerm_network_interface" "hcmxexample" {
  name                = var.vm_name
  resource_group_name = var.os_type=="linux" ? azurerm_linux_virtual_machine.hcmxexample[0].resource_group_name : azurerm_windows_virtual_machine.hcmxexample[0].resource_group_name
  #resource_group_name = var.resource_group_name
}

output "network_interface_name" {
  value = data.azurerm_network_interface.hcmxexample.id
}

output "private_ip_address" {
  value = data.azurerm_network_interface.hcmxexample.private_ip_address
}

output "primary_dns_name" {
  value = data.azurerm_public_ip.hcmxexample.fqdn
}

# output "resource_group_name" {
#   value = var.os_type=="linux" ? azurerm_linux_virtual_machine.hcmxexample[0].name : azurerm_windows_virtual_machine.hcmxexample[0].name
# }

# output "network_security_group_name" {
#   value = data.azurerm_network_security_group.hcmxexample.name
# }

# output "azurerm_subnet" {
#   value = data.azurerm_subnet.hcmxexample.name
# }

# output "virtual_network_name" {
#   value = data.azurerm_subnet.hcmxexample.virtual_network_name
# }

output "azurerm_network_interface" {
  value = azurerm_network_interface.hcmxexample.name
}

# output "size" {
#   value = var.os_type=="linux" ? azurerm_linux_virtual_machine.hcmxexample[0].size : azurerm_windows_virtual_machine.hcmxexample[0].size
# }

output "virtual_machine_id" {
  value = var.os_type=="linux" ? azurerm_linux_virtual_machine.hcmxexample[0].virtual_machine_id : azurerm_windows_virtual_machine.hcmxexample[0].virtual_machine_id
}

output "mac_address" {
  value = azurerm_network_interface.hcmxexample.mac_address
}

output "cloud_instance_id" {
  value = var.os_type=="linux" ? azurerm_linux_virtual_machine.hcmxexample[0].id : azurerm_windows_virtual_machine.hcmxexample[0].id
}

#output "azurerm_private_dns_zone" {
#  value = azurerm_private_dns_zone.hcmxexample.name
#}

output "data_disk_name" {
  value = azurerm_managed_disk.hcmxexample.name
}




