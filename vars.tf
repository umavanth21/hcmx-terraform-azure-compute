variable "subscription_id" {
 default = "subscription_id"
  }
variable "client_id" {
 default = "client_id"
  }
variable "tenant_id" {
  default = "tenant_id"
  }
variable "client_secret" {
  default = "client_secret"
  }
variable "password" {
  default = "Admblabla!!!"
  }
variable "admin" {
  description = "Default user with root access"
 # type = "map"
  default = {
    name = "terraform"
    public_key = ""
  }
}

variable "namespace" {
  description = "Prefix for resource names"
  default="cyphert"
}
variable "name" {
  description = "Name of the service"
  default="testing"
}
variable "location" {
  description = "Resource location. To see full list run 'az account list-locations'"
  default="westus"
}
variable "cidr" {
  default = "10.0.0.0/16"
}
variable "subnet" {
  default = "10.0.1.0/24"
}
variable "vm_size" {
  description = "Size of the vm. To see full list run 'az vm list-sizes'"
  default="Basic_A0"
}
variable "vm_disk_type" {
  description = "Storage class. Can be Standard_LRS or Premium_LRS"
  default = "Standard_LRS"
}
variable "allocation_method" {
  description = "Defines how an IP address is assigned. Options are Static or Dynamic."
  default     = "Dynamic"
}
#variable "os" {
  #description = "Disk image with preinstalled OS"
 # type = "map"
 # default = {
    #publisher = "OpenLogic"
    #offer = "CentOS"
    #sku = "7.4"
    #os_version = "latest"
  #}
#}

variable "os_type" {
  description = "OS Type of the VM. Valid values are - windows, linux"
  default="windows"
}

variable "username" {
  description = "The username for the target VM"
  type   = string
  default = "Administrators"
  }

variable "publisher" {
  default="MicrosoftWindowsServer"
  description = "The Publisher"
  type   = string
  }


variable "tag1" {
  type   = string
  default = "cypher"
  }

variable "offer" {
  type   = string
  default = "WindowsServer"
  }

variable "sku" {
  type   = string
  default = "2019-Datacenter"
  }

variable "os_version" {
   type   = string
  default = "latest"
  }

variable "domain_name_label" {
   type   = string
  default = "ameydw1234"
  }
