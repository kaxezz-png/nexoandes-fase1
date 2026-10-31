output "vpc_id" {
  description = "ID de la VPC."
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID de la subred publica."
  value       = aws_subnet.public.id
}

output "subnet_cidr" {
  description = "CIDR de la subred publica."
  value       = aws_subnet.public.cidr_block
}
