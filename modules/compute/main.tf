# AMI Amazon Linux 2023 mas reciente (systemd + dnf; nginx sirve en /usr/share/nginx/html).
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "portal" {
  # Excepciones de seguridad justificadas (alcance Fase 1, laboratorio de costo controlado):
  #checkov:skip=CKV_AWS_135:EBS optimized no aplica a todos los tipos de instancia permitidos en el laboratorio
  #checkov:skip=CKV_AWS_126:Monitoreo detallado tiene costo y el monitoreo avanzado esta fuera de alcance de la Fase 1
  #checkov:skip=CKV2_AWS_41:El laboratorio no permite crear roles IAM y el portal no consume APIs AWS

  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  user_data                   = var.user_data
  user_data_replace_on_change = true

  # IMDSv2 obligatorio: el portal consulta los datos de la instancia con token.
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-portal" })
}
