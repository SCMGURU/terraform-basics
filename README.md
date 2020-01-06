# terraform-basics
learn basics of Terraform with Azure
- run terraform init to download respective provider plugin


# 1: terraform first working script to create single VM
  
- variables created in seperate file variable.tf
- connections.tf file for azure acount connection 
- "output" introduction which is applicable only with apply.

run "terraform plan" and "terraform apply" to create resource.

# 2: adding list in variables and creating multiple VM's 
Following list of task done: 
- count variable of list type added
- calculate length of list.
- each vm have its own storage and nic so script changed accordingly to loop through each index
- element introduction
- output adjusted accordingly. 
- output logs file added

run "terraform plan" and "terraform apply" to create resource.

# 3: adding maps variable , using join fucntion in terraform
Following list of task done: 
- Added machine_type varialbe as map and used it for size based on "prod or "dev" value
	vm_size               =  "${var.machine_type["dev"]}"

- we can add join function in terraform as follows: 
 output "name" { value = "${join("," , azurerm_virtual_machine.main.*.id)}"}

we will see output as follows: 
name = /subscriptions/******/resourceGroups/tfvmex-resources/providers/Microsoft.Compute/virtualMachines/vm-1,/subscriptions//******//resourceGroups/tfvmex-resources/providers/Microsoft.Compute/virtualMachines/vm-2,/subscriptions/******/resourceGroups/tfvmex-resources/providers/Microsoft.Compute/virtualMachines/vm-3

# 4: Adding depends_on and if_else

- depends_on sets build order for creation of respective resoruces. Here resource group "two" is built first before "main". Only relected during "apply". Added log for same.

# 5: Adding IF_ELSE fucntion 
- added variables environemnt and machine_type which is picked up based on value of environment:
vm_size               = "${"${var.environment}" == "prod" ?  var.machine_type_prod : var.machine_type_dev}"






