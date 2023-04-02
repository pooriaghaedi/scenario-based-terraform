resource "aws_security_group" "bastion" {
  description = "Allow SSH to the bastion"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = local.BastionPort
    to_port     = local.BastionPort
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = local.BastionAMI
  instance_type               = local.BastionInstanceType
  key_name                    = local.BastionKeyName
  vpc_security_group_ids      = [aws_security_group.bastion.id] //you can add your DB security group here
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data = file("${path.module}/init.sh")
  root_block_device {
    volume_size = "8"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
}