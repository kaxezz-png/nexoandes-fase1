variable "name_prefix" {
  type        = string
  description = "Prefijo para los nombres de recursos."
}

variable "vpc_id" {
  type        = string
  description = "VPC donde se crea el Security Group."
}

variable "tags" {
  type        = map(string)
  description = "Tags comunes."
  default     = {}
}
