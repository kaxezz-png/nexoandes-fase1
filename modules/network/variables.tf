variable "name_prefix" {
  type        = string
  description = "Prefijo para los nombres de recursos."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR de la VPC."
  default     = "172.16.0.0/16"
}

variable "student_number" {
  type        = number
  description = "Numero de lista; define X en 172.16.X.0/24."
}

variable "tags" {
  type        = map(string)
  description = "Tags comunes."
  default     = {}
}
