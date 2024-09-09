variable "intra_subnets" {
  description = "intra subnets"
  type        = list(string)
}

variable "intra_subnet_tags" {
  description = "intra subnet tags"
  type        = map(string)

  default = {
    module-component      = "subnet"
    module-component-type = "subnet-intra"
  }
}

variable "name" {
  description = "Name of the vpc"
  type        = string
  default     = ""
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
}

variable "private_subnet_tags" {
  description = "Private subnet tags"
  type        = map(string)

  default = {
    module-component      = "subnet"
    module-component-type = "subnet-private"
  }
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "public_subnet_tags" {
  description = "Public subnet tags"
  type        = map(string)

  default = {
    module-component      = "subnet"
    module-component-type = "subnet-public"
  }
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)

  default = {
    module = "vpc"
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC where resources will be deployed"
  type        = string
  default     = "10.230.0.0/16"
}