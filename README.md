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


