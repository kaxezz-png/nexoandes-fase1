mock_provider "aws" {}

run "red_segun_arquitectura_de_referencia" {
  command = plan

  module {
    source = "./modules/network"
  }

  variables {
    name_prefix    = "test"
    student_number = 17
  }

  assert {
    condition     = aws_vpc.this.cidr_block == "172.16.0.0/16"
    error_message = "La VPC debe usar 172.16.0.0/16."
  }

  assert {
    condition     = aws_subnet.public.cidr_block == "172.16.17.0/24"
    error_message = "La subred debe ser 172.16.X.0/24 con X = numero de lista."
  }

  assert {
    condition     = aws_subnet.public.map_public_ip_on_launch == true
    error_message = "La subred publica debe asignar IPv4 publica al lanzar."
  }

  assert {
    condition     = one([for r in aws_route_table.public.route : r.cidr_block]) == "0.0.0.0/0"
    error_message = "La Route Table debe tener la ruta 0.0.0.0/0 hacia el Internet Gateway."
  }
}
