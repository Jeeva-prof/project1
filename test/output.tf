output "masterip" {
  value = aws_instance.EC2.public_ip
}

output "nodeip" {
 value = aws_instance.EC21.public_ip
}
