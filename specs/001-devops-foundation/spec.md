# Spec 001: DevOps foundation

- **R1:** The system shall define all lab Azure resources as code, using the agreed names and tags.
- **R2:** The system shall store Terraform state remotely, outside the repository.
- **R3:** When a pull request is opened, the pipeline shall run validation and `terraform plan`.
- **R4:** When a deployment is approved, the pipeline shall run `terraform apply`.
- **R5:** The pipeline shall authenticate with OIDC, without client secrets.
- **R6:** The pipeline identity shall not have permissions outside the lab resources.
- **R7:** When a version is released, the system shall deploy a versioned image to Azure Container Apps.
- **R8:** If a version fails, the system shall allow a return to the previous version and verify it.
- **R9:** When the exercise ends, the system shall remove the resources with `terraform destroy` and verify the result.
- **R10:** The public repository shall not contain secrets or personal or sensitive tenant data.

---
© 2026 VIDAL ECOSYSTEM
