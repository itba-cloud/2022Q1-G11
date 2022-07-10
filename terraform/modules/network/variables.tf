variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "vpc_tenancy" {
  type        = string
  description = "VPC tenancy"
}

variable "vpc_tag_name" {
  type        = string
  description = "VPC tag for resource identification"
}

variable "subnet_cidr" {
  type        = string
  description = "Subnet CIDR"
}

variable "subnet_az" {
  type        = string
  description = "Subnet's availability zone "
}

variable "subnet_tag_name" {
  type        = string
  description = "Subnet tag for resource identification"
}

variable "sg_tag_name" {
  type        = string
  description = "Security group tag for resource identification"
}

variable "ingress_protocol" {
  type        = number
  description = "Ingress chosen protocol"
}

variable "ingress_self" {
  type        = bool
  description = "Whether ingress to self is permitted or not"
}

variable "ingress_from_port" {
  type        = number
  description = "From port number"
}

variable "ingress_to_port" {
  type        = number
  description = "To port number"
}

variable "egress_from_port" {
  type        = number
  description = "From port number"
}

variable "egress_to_port" {
  type        = number
  description = "To port number"
}

variable "egress_protocol" {
  type        = number
  description = "Egress chosen protocol"
}

variable "egress_cidr" {
  type        = list(any)
  description = "Egress CIDR"
}