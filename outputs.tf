output "vpc-id" {
  value = aws_vpc.vmvpc.id

}
output "host_ip" {
  value = aws_instance.web1_nginx_instance.public_ip
}
output "public_subnets" {
  value = data.aws_subnets.public_subnets.ids
}
output "private_subnets" {
  value = data.aws_subnets.private_subnets.ids
}
