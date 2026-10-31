mock_provider "aws" {}

run "instancia_con_imdsv2_obligatorio" {
  command = plan

  module {
    source = "./modules/compute"
  }

  variables {
    name_prefix       = "test"
    subnet_id         = "subnet-12345678"
    security_group_id = "sg-12345678"
    instance_type     = "t3.micro"
    user_data         = "#!/bin/bash"
  }

  assert {
    condition     = aws_instance.portal.metadata_options[0].http_tokens == "required"
    error_message = "IMDSv2 debe ser obligatorio (http_tokens = required)."
  }

  assert {
    condition     = aws_instance.portal.root_block_device[0].encrypted == true
    error_message = "El volumen raiz debe estar cifrado."
  }

  assert {
    condition     = aws_instance.portal.user_data_replace_on_change == true
    error_message = "user_data_replace_on_change debe estar activo."
  }
}
