mock_provider "aws" {}

run "composicion_modular_fase1" {
  command = plan

  variables {
    student_name   = "Test"
    student_number = 17
  }

  assert {
    condition     = module.network.subnet_cidr == "172.16.17.0/24"
    error_message = "El root module debe componer la red con la subred 172.16.X.0/24."
  }
}

run "rechaza_numero_de_lista_fuera_de_rango" {
  command = plan

  variables {
    student_name   = "Test"
    student_number = 300
  }

  expect_failures = [var.student_number]
}
