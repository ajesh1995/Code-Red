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
