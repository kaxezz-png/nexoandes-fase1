# NexoAndes Portal Operacional V1 - Fase 1 (IaC)

Evaluacion Sumativa U1 - IC106TICL Automatizacion de Infraestructura con IaC.
Autor: **Camilo Sebastián Muñoz Ortiz** - N.o de lista: **[N]**

Infraestructura AWS del Portal Operacional descrita con Terraform (root module + modulos locales),
versionada con Git y desplegada mediante un pipeline de GitHub Actions con controles, plan y gate.

## Arquitectura (Fase 1)
VPC `172.16.0.0/16` - subred publica `172.16.X.0/24` (X = n.o de lista) - Internet Gateway - Route Table
(`0.0.0.0/0` -> IGW) - Security Group (HTTP TCP/80, sin SSH) - EC2 Amazon Linux 2023 con nginx y el
portal via `user_data` (IMDSv2 obligatorio).

## Estructura
```
.
|-- main.tf / variables.tf / outputs.tf / versions.tf / backend.tf   # root module
|-- modules/network/    # VPC, subred publica, IGW, Route Table y asociacion, SG por defecto restringido
|-- modules/security/   # Security Group del portal (HTTP/80)
|-- modules/compute/    # AMI (data source) + EC2 con user_data
|-- templates/user_data_v1.sh.tpl   # artefacto del docente, sin modificar
|-- tests/              # pruebas IaC con aserciones (terraform test)
|-- .github/workflows/iac-pipeline.yml
|-- .tflint.hcl / .checkov.yaml / .gitignore / .gitattributes
`-- fase1.auto.tfvars   # nombre y n.o de lista (no es secreto)
```

## Prerrequisitos
- Terraform >= 1.10, AWS CLI v2, Git.
- AWS Academy Learner Lab iniciado (credenciales temporales).
- Bucket S3 de state creado previamente (ver "State").

## Convencion de commits
`tipo: descripcion breve en minusculas`
- `iac:` codigo Terraform - `ci:` pipeline - `test:` pruebas - `docs:` documentacion - `chore:` mantenimiento

## Flujo de trabajo Git
1. Rama principal `main` protegida por revision. 2. Trabajo en `feature/fase1-nexoandes`.
3. `git add` -> `git commit` (atomico) -> `git push`. 4. Pull Request a `main` con objetivo, alcance y controles.
5. Revision y merge solo con controles en verde. 6. El merge a `main` dispara el despliegue.

## Pipeline (GitHub Actions)
`controles` (fmt -check, validate, terraform test, tflint, checkov) -> `plan` -> `gate` (aprobacion manual
en Environment `aprobacion-despliegue`) -> `apply` del plan aprobado -> `verificar` (output, AWS CLI, HTTP,
plan posterior sin cambios). Limpieza: ejecutar manualmente (workflow_dispatch) con `action = destroy`.

## State y secretos
- State remoto en S3 con locking nativo (`use_lockfile`). **El state nunca se versiona.**
- Bucket entregado en `terraform init -backend-config` (variable de Actions `TF_STATE_BUCKET`).
- Credenciales temporales del Learner Lab como *secrets* de GitHub (`AWS_ACCESS_KEY_ID`,
  `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`). No existen credenciales en codigo, logs, ZIP ni evidencias.

## Excepciones de seguridad justificadas (checkov)
| Check | Motivo |
|---|---|
| CKV_AWS_260 | La arquitectura exige HTTP/80 abierto a Internet para el portal publico |
| CKV_AWS_130 | Subred publica con IPv4 publica al lanzar, segun arquitectura de referencia |
| CKV_AWS_135 | EBS optimized no aplica a todos los tipos de instancia permitidos |
| CKV_AWS_126 | Monitoreo detallado tiene costo; monitoreo avanzado fuera de alcance |
| CKV2_AWS_11 | VPC Flow Logs fuera de alcance de la Fase 1 |
| CKV2_AWS_5 | El SG se asocia a la EC2 desde otro modulo (falso positivo por modulos) |
| CKV2_AWS_41 | El laboratorio no permite roles IAM; el portal no consume APIs AWS |

## Despliegue y limpieza
Despliegue: merge a `main` -> aprobar el gate. Limpieza: Actions -> `iac-pipeline` -> *Run workflow* ->
`destroy` -> aprobar. El job verifica con AWS CLI que no quedan instancias ni VPC con las tags del proyecto.
El bucket de state es infraestructura de soporte y se elimina manualmente al cerrar la evaluacion.

## Referencias
HashiCorp. (2025). *Terraform documentation*. https://developer.hashicorp.com/terraform
