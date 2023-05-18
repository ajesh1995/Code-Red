#####CREATING VPC 

resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

####IGW

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = var.vpc_igw_name
  }
}

####ROUTE TABLE 


resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }


  tags = {
    Name = var.vpc_route_name

	}
}


####subnet

resource "aws_subnet" "mysub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.vpc_sub_cidr

  tags = {
    Name = "var.vpc_sub_name"
  }
}

route to subnet association

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mysub.id
  route_table_id = aws_route_table.myroute.id
}


####SECURITY GROUP

resource "aws_security_group" "security_group" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.vpc_sg_name
  }
}

####keypair
resource "aws_key_pair" "mykey" {
  key_name   = var.mykey
  public_key = var.mykey_pub
}


#####EC2 

resource "aws_instance" "web" {
  ami           = var.myamiid
  instance_type = var.instance_type
  key_name = aws_key_pair.mykey.key_name
  subnet_id = aws_subnet.mysub.id
  vpc_security_group_ids =[aws_security_group.mysg.id]
  depends_on = [aws_key_pair.mykey,aws_vpc.myvpc]

  tags = {
    Name = var.instance_name
  }
}



######VARIABLE.TF

variable "region_name" {}
variable "bucket_name" {}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "vpc_igw_name" {}
variable "vpc_route_name" {}
variable "vpc_sub_cidr" {}
variable "vpc_sub_name" {}
variable "vpc_sg_name" {}
variable "mykey_pub" {}
variable "mykey" {}
variable "myamiid" {}
variable "instance_type" {}
variable "instance_name" {}


######MYVARS.TFVARS


region_name="us-east-1"
bucket_name="batch42024dvaws"
vpc_cidr="10.150.0.0/16" 
vpc_name="batch4-vpc"
vpc_igw_name="batch4-igw"
vpc_route_name="batch4-route1"
vpc_sub_cidr="10.150.15.0/24"
vpc_sub_name="batch4-sub1"
vpc_sg_name="batch4-sg1"
mykey_pub="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYlFbrq0+Hy+5M0ll3HL7GQEKSLJuYrMC8ZX0jtacXo75AodsCIjExnW5iYTrGKO/FvbAFdIKZ9TzFe8w0lCuay3VeMWWSQb05bnRw7keFhguSY0Wb8+XHTN+HyY5HpGHcz6JdC7z1hThrYoQCaeD9xhYcIbzPHFEgO7tbtqZl5h3g67g1otTdKHjJYi8TpThKUCHfj4dUqBsgLG3d3sxaP3zOQp5fC9zF1Xm490CUIyIsAaYBmcieYC0hAMdCRr8jjFk9rfQqvJrqufRrpcA9HpEFytrYBq+lw8mIPWiZP8G3tjGa2R2FEry7F/dVMAv3Z/x23fYNC/DGmfQxAheN imported-openssh-key"
mykey="batch4-key1"
myamiid="ami-0889a44b331db0194"
instance_type="t2-micro"
instance_name="batch4-server1"
subnet_id= "" ??




output "subnet_id" {
       value = aws_subnet.mysub.id
}

output "scr_grp_id" {
        value = aws_security_group.mysg.id
}

EC2

module "app1_ec2" {
       source = "/root/mymodules/ec2"
       region_name = var.region_name
       mykey_pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYlFbrq0+Hy+5M0ll3HL7GQEKSLJuYrMC8ZX0jtacXo75AodsCIjExnW5iYTrGKO/FvbAFdIKZ9TzFe8w0lCuay3VeMWWSQb05bnRw7keFhguSY0Wb8+XHTN+HyY5HpGHcz6JdC7z1hThrYoQCaeD9xhYcIbzPHFEgO7tbtqZl5h3g67g1otTdKHjJYi8TpThKUCHfj4dUqBsgLG3d3sxaP3zOQp5fC9zF1Xm490CUIyIsAaYBmcieYC0hAMdCRr8jjFk9rfQqvJrqufRrpcA9HpEFytrYBq+lw8mIPWiZP8G3tjGa2R2FEry7F/dVMAv3Z/x23fYNC/DGmfQxAheN imported-openssh-key"
       mykey = "app1-key1"
       myamiid = "ami-06a0cd9728546d178"
       instance_type = "t2.micro"
       instance_name = "app1-server1"
       sec_grp_id = module.app1_vpc.sec_grp_id
       sub_id = module.app1_vpc.subnet_id

