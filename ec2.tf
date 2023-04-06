variable "ami_id" {

  type    = string
  default = "ami-02eb7a4783e7e9317"

}
resource "aws_key_pair" "mykey" {
  key_name   = "vmkey"
  public_key = file("./id_rsa.pub")
}
resource "aws_security_group" "vmvpc_sg" {
  name        = "vmvpc_sg"
  description = "allows 80 and 22"
  vpc_id      = aws_vpc.vmvpc.id
  ingress {
    cidr_blocks = [local.anywhere]
    description = "allows 80 port"
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = [local.anywhere]
    description = "allows 22 port"
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    protocol    = "tcp"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "vmvpc_sg"
  }
  depends_on = [
    aws_vpc.vmvpc
  ]
}
resource "aws_instance" "web1_nginx_instance" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.mykey.id
  vpc_security_group_ids      = [aws_security_group.vmvpc_sg.id]
  subnet_id                   = data.aws_subnets.public_subnets.ids[1]
  tags = {
    "Name" = "web1_nginx_instance"
  }
  depends_on = [
    data.aws_subnets.public_subnets,
    aws_subnet.subnets,
    aws_security_group.vmvpc_sg
  ]
}
# resource "aws_instance" "web1_apache_instance" {
#   ami                         = var.ami_id
#   instance_type               = "t2.micro"
#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.mykey.id
#   vpc_security_group_ids      = [aws_security_group.vmvpc_sg.id]
#   subnet_id                   = data.aws_subnets.public_subnets.ids[0]
#   tags = {
#     "Name" = "web1_apache_instance"
#   }
#   depends_on = [
#     data.aws_subnets.public_subnets,
#     aws_subnet.subnets,
#     aws_security_group.vmvpc_sg
#   ]
# }

# resource "null_resource" "null_rsc_nginx" {
#   triggers = {
#     version = var.application_version
#   }
#   connection {
#     host        = aws_instance.web1_nginx_instance.public_ip
#     user        = "ubuntu"
#     private_key = file("./id_rsa")
#     type        = "ssh"
#   }
#   provisioner "remote-exec" {
#     inline = ["sudo apt-get update", "sudo apt-get install nginx -y"]

#   }
#   depends_on = [
#     aws_instance.web1_nginx_instance
#   ]
# }
# resource "null_resource" "null_rsc_apache" {
#   triggers = {
#     version = var.application_version
#   }
#   connection {
#     host        = aws_instance.web1_apache_instance.public_ip
#     user        = "ubuntu"
#     private_key = file("./id_rsa")
#     type        = "ssh"
#   }
#   provisioner "remote-exec" {
#     inline = ["sudo apt-get update", "sudo apt-get install apache2 -y"]

#   }
#   depends_on = [
#     aws_instance.web1_apache_instance
#   ]
# }