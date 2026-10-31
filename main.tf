locals {
  name_prefix = "nexoandes-${var.environment}-${var.student_number}"

  common_tags = {
    StudentNumber = tostring(var.student_number)
    Project       = "NexoAndes"
    Phase         = "Fase1"
  }

  portal_user_data = templatefile(
    "${path.module}/templates/user_data_v1.sh.tpl",
    {
      student_name   = var.student_name
      student_number = tostring(var.student_number)
      environment    = var.environment
      portal_version = var.portal_version
      project_name   = var.project_name
    }
  )
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

module "network" {
  source = "./modules/network"

  name_prefix    = local.name_prefix
  student_number = var.student_number
  tags           = local.common_tags
}

module "security" {
  source = "./modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
  tags        = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  name_prefix       = local.name_prefix
  subnet_id         = module.network.subnet_id
  security_group_id = module.security.security_group_id
  instance_type     = var.instance_type
  user_data         = local.portal_user_data
  tags              = local.common_tags

  # La instancia descarga nginx en el arranque: necesita la ruta a Internet lista.
  depends_on = [module.network]
}
