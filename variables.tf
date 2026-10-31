variable "aws_region" {
  type        = string
  description = "Region AWS autorizada para el laboratorio."
  default     = "us-east-1"
}

variable "student_name" {
  type        = string
  description = "Nombre del estudiante (se muestra en el portal)."
}

variable "student_number" {
  type        = number
  description = "Numero de lista. Define X en la subnet 172.16.X.0/24."

  validation {
    condition     = var.student_number >= 1 && var.student_number <= 254 && floor(var.student_number) == var.student_number
    error_message = "student_number debe ser un entero entre 1 y 254."
  }
}

variable "environment" {
  type        = string
  description = "Ambiente de la fase."
  default     = "fase1"
}

variable "portal_version" {
  type        = string
  description = "Version visible del portal."
  default     = "v1"
}

variable "project_name" {
  type        = string
  description = "Nombre del proyecto."
  default     = "NexoAndes Portal Operacional"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia EC2. Confirmar el permitido en la guia vigente / entorno."
  default     = "t3.micro"
}
