output "masterip" {
  value = aws_instance.master.public_ip
}

output "nodeip" {
 value = aws_instance.node.public_ip
}
