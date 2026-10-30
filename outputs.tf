output "vpc_id" {
  description = "ID de la VPC."
  value       = module.network.vpc_id
}

output "subnet_id" {
  description = "ID de la subred publica."
  value       = module.network.subnet_id
}

output "instance_id" {
  description = "Instance ID de la EC2 del portal."
  value       = module.compute.instance_id
}

output "public_ip" {
  description = "IP publica de la instancia."
  value       = module.compute.public_ip
}

output "portal_url" {
  description = "URL HTTP del Portal Operacional."
  value       = "http://${module.compute.public_ip}/"
}
