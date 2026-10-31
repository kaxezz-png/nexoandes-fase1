variable "name_prefix" {
  type        = string
  description = "Prefijo para los nombres de recursos."
}

variable "subnet_id" {
  type        = string
  description = "Subred publica donde se lanza la instancia."
}

variable "security_group_id" {
  type        = string
  description = "Security Group asociado a la instancia."
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia EC2."
}

variable "user_data" {
  type        = string
  description = "Contenido renderizado del user data del portal."
}

variable "tags" {
  type        = map(string)
  description = "Tags comunes."
  default     = {}
}
