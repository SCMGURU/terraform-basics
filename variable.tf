variable "name" { default = "resources" }

variable "prefix" { default = "tfvmex" }

variable "location" { default = "West US 2"}

variable "size" { default = "1024M" }

variable "name_count" { default = ["server1", "server2" , "server3"]}

# variable "machine_type" {
#       type = "map"
#       default = {
#         "dev" = "Standard_DS1_v2"
#         "prod" = "Standard_DS2_v2"
      
#       }
# }

variable "machine_type_dev" { default = "Standard_DS1_v2" }

variable "machine_type_prod" { default = "Standard_DS2_v2" }

variable "environment" { default = "prod"}

