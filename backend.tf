# Backend remoto en S3 con locking nativo (use_lockfile).
# El bucket NO se escribe aqui: se entrega en terraform init (-backend-config)
# para no dejar nombres de infraestructura de soporte fijos en el codigo.
terraform {
  backend "s3" {
    key          = "nexoandes/fase1/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}
