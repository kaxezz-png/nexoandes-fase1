mock_provider "aws" {}

run "solo_http_sin_ssh" {
  command = plan

  module {
    source = "./modules/security"
  }

  variables {
    name_prefix = "test"
    vpc_id      = "vpc-12345678"
  }

  assert {
    condition     = aws_vpc_security_group_ingress_rule.http.from_port == 80 && aws_vpc_security_group_ingress_rule.http.to_port == 80
    error_message = "La unica regla de entrada debe ser HTTP TCP/80."
  }

  assert {
    condition     = aws_vpc_security_group_ingress_rule.http.ip_protocol == "tcp"
    error_message = "La regla de entrada debe ser TCP."
  }
}
