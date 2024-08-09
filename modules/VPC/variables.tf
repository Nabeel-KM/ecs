variable "vpc_cidr_blocks" {
    default = "10.0.0.0/20" 
}

variable "subnet_cidr_blocks" {
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr_blocks" {
    default = "10.0.2.0/24"
}