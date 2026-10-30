resource "aws_security_group" "portal" {
  #checkov:skip=CKV2_AWS_5:El Security Group se asocia a la EC2 desde otro modulo (compute)

  name        = "${var.name_prefix}-sg"
  description = "HTTP TCP 80 para Portal Operacional NexoAndes"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name_prefix}-sg" })
}

# Entrada: solo HTTP. No se abre SSH (TCP/22 no requerido).
resource "aws_vpc_security_group_ingress_rule" "http" {
  #checkov:skip=CKV_AWS_260:El portal publico debe aceptar HTTP/80 desde Internet segun la arquitectura de referencia

  security_group_id = aws_security_group.portal.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "HTTP desde Internet"
}

# Salida: necesaria para que el bootstrap instale nginx.
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.portal.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Salida a Internet para bootstrap"
}
