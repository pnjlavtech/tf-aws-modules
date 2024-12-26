variable "alb_sg_name" {
  description = "ALB SG Name"
  type        = string
  default     = "dev-us-west-2-alb-sg"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {
    module = "sg"
  }
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string

  default = "vpc-0d92a29a969c4f59d"

}


