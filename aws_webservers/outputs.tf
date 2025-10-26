output "public_ip" {
  description = "The public IP address of the first EC2 instance."
  # References the public_ip of the first instance created by the module
  value       = aws_instance.my_amazon[0].public_ip
}

output "static_eip" {
  description = "The public IP address of the Elastic IP."
  # References the public_ip of the EIP resource created by the module
  value       = aws_eip.static_eip.public_ip
}
