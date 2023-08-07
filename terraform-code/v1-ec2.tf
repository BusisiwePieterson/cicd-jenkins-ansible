provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-09538990a0c4fe9be"
    instance_type = "t2.micro"
    key_name = "newkeypair"
}