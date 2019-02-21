variable "public_key_path" {
  description = <<EOT
  Path to the SSH public key to be used for authentication.
  Ensure this keypair is added to your local SSH agent so provisioners can
  connect.
EOT
  default = "~/terraform.pub"
}

variable "key_name" {
  default = "terraform-key"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_amis" {
  default = {
    eu-west-1 = "ami-674cbc1e"
    us-east-1 = "ami-1d4e7a66"
    us-west-1 = "ami-969ab1f6"
    us-west-2 = "ami-8803e0f0"
  }
}
