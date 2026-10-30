output "security_group_id" {
  description = "ID del Security Group del portal."
  value       = aws_security_group.portal.id
}
