provider "aws" {
  region	= "${var.aws_region}"
  shared_credentials_file = "~/.aws/credentials"
  profile = "terraform"
}

resource "aws_vpc" "tfvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "tfigw" {
  vpc_id = "${aws_vpc.tfvpc.id}"
}

resource "aws_route" "tfroute" {
  route_table_id = "${aws_vpc.tfvpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.tfigw.id}"
}

resource "aws_subnet" "tfsubnet" {
  vpc_id = "${aws_vpc.tfvpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
}

resource "aws_security_group" "tfelbsg" {
  name = "tf_example_elb_sg"
  vpc_id = "${aws_vpc.tfvpc.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "tfec2sg" {
  name = "tf_ec2_sg"
  vpc_id = "${aws_vpc.tfvpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "tfelb" {
  name = "elb80"

  subnets = ["${aws_subnet.tfsubnet.id}"]
  security_groups = ["${aws_security_group.tfec2sg.id}"]
  instances = ["${aws_instance.tfinst.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}

resource "aws_key_pair" "tfkeypair" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "tfinst" {

  instance_type = "t2.micro"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${aws_key_pair.tfkeypair.id}"
  vpc_security_group_ids = ["${aws_security_group.tfec2sg.id}"]
  subnet_id = "${aws_subnet.tfsubnet.id}"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get -y update
              sudo apt-get -y install nginx
              sudo service nginx start
              EOF

}
