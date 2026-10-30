output "instance_id" {
  description = "Instance ID."
  value       = aws_instance.portal.id
}

output "public_ip" {
  description = "IP publica."
  value       = aws_instance.portal.public_ip
}

output "private_ip" {
  description = "IP privada."
  value       = aws_instance.portal.private_ip
}
