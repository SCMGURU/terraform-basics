 
#teraform working script for creating multiple VM's
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.name}"
  location =  var.location #another way to define variable from terraform

  depends_on = ["azurerm_resource_group.two"] # resource group two will be build first

}
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  depends_on = ["azurerm_resource_group.main"]

}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.2.0/24"

  #subnet should not be build unless resource group exists
  depends_on = ["azurerm_resource_group.main"]
}

resource "azurerm_network_interface" "main" {
  count               = "${length(var.name_count)}"
  name                = "${var.prefix}-nic-${count.index+1}"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  count                 =   1
  #count                 = "${length(var.name_count)}"
  #name                  = "${var.prefix}-vm"
  name                  = "vm-${count.index+1}"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  #network_interface_ids = ["${azurerm_network_interface.main.id}"]
  network_interface_ids = ["${element(azurerm_network_interface.main.*.id, count.index)}"]
  #vm_size               =  "${var.machine_type["dev"]}"  # here we define which mahcine type based on variables's value.
  vm_size               = "${"${var.environment}" == "prod" ?  var.machine_type_prod : var.machine_type_dev}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1-${count.index+1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

#defining another resource group which depends on 1: 

resource "azurerm_resource_group" "two" {
  name     = "${var.prefix}-two"
  location =  var.location #another way to define variable from terraform

}

output "virtual_machine_name" { value="${azurerm_resource_group.main.*.name}"}

output "virtual_machine_location" {value = "${azurerm_resource_group.main.*.location}"}

output "azurerm_subnet" { value ="${azurerm_subnet.internal.*.name}"}

output "vnet-name" { value = "${azurerm_virtual_network.main.*.name}"}

output "virtualbox" { value = "${azurerm_virtual_machine.main.*.name}"}

#output "virtual" { value = "${azurerm_virtual_machine.main.vm_size}"}

output "name" { value = "${join("," , azurerm_virtual_machine.main.*.id)}"}

