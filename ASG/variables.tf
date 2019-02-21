variable "aws_region" {
  default = "us-east-1"
}
variable "aws_amis" {
  default = {
    "us-east-1" = "ami-5f709f34"
    "us-west-2" = "ami-7f675e4f"
  }
}
variable "availability_zones" {
  default = "us-east-1b,us-east-1c"
}

variable "subnets" {
  default = "subnet-9cb1bdb3,subnet-61ac1f2b"
}
variable "key_name" {
  description = "Name of AWS Key Pair"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "asg_min" {
  default = "1"
}
variable "asg_max" {
  default = "2"
}
variable "asg_desired" {
  default = "1"
}
