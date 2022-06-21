resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.vpc_tenancy

  tags = {
    Name = var.vpc_tag_name
  }
}

resource "aws_subnet" "this" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.subnet_az

  tags = {
    Name = var.subnet_tag_name
  }
}

//TODO check values
resource "aws_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol  = var.ingress_protocol  //-1
    self      = var.ingress_self      //true
    from_port = var.ingress_from_port //0
    to_port   = var.ingress_to_port   //0
  }

  egress {
    from_port   = var.egress_from_port //0
    to_port     = var.egress_to_port   //0
    protocol    = var.egress_protocol  //-1
    cidr_blocks = var.egress_cidr      //["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_tag_name
  }
}