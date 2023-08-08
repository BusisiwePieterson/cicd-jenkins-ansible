provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-09538990a0c4fe9be"
    instance_type = "t2.micro"
    key_name = "newkeypair"
    #security_groups = ["demo-sg"]
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.project-public-subnet-01.id
    for_each = toset(["jenkins-master", "build-slave", "ansible"])
    tags = {
        Name = "${each.key}"
    }
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id = aws_vpc.project-vpc.id


#inboud rule
  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

#outbound rule
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-protocol"
  }
}


resource "aws_vpc" "project-vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
        Name = "project-vpc"
    }
}

resource "aws_subnet" "project-public-subnet-01" {
    vpc_id = aws_vpc.project-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
        Name = "project-public-subnet-01"
    }
}

resource "aws_subnet" "project-public-subnet-02" {
    vpc_id = aws_vpc.project-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
        Name = "project-public-subnet-02"
    }
}

resource "aws_internet_gateway" "project-igw" {
    vpc_id = aws_vpc.project-vpc.id
    tags = {
        Nmae = "project-igw"
    }
}

resource "aws_route_table" "project-public-rt" {
    vpc_id = aws_vpc.project-vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.project-igw.id
    }
}

resource "aws_route_table_association" "project-rta-public-subnet-01" {
    subnet_id = aws_subnet.project-public-subnet-01.id
    route_table_id = aws_route_table.project-public-rt.id
}

resource "aws_route_table_association" "project-rta-public-subnet-02" {
    subnet_id = aws_subnet.project-public-subnet-02.id
    route_table_id = aws_route_table.project-public-rt.id
}

