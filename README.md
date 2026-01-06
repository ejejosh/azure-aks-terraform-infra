# Terraform Azure Infrastructure Deployment

This repository provisions Azure infrastructure using **Terraform** with **GitHub Actions** automation.  

It deploys the following resources in Azure:
- **Resource Group**
- **Azure Kubernetes Service (AKS)**
- **Azure Key Vault**
- **Azure AD Service Principal**

Infrastructure is managed through modular Terraform code and automated workflows for creation and destruction.

---

## Project Structure


---

## Automated Workflow

Infrastructure is managed via **GitHub Actions** instead of manual CLI runs.  
There are two workflows:

### 1. Create / Update (Provision Infrastructure)

- Workflow: [`.github/workflows/create.yaml`](.github/workflows/create.yaml)
- Triggers:
  - Push to `main` branch
  - Pull request events (`review_requested`, `ready_for_review`, `synchronize`)
  - Manual run (`workflow_dispatch`)

Steps executed:
1. Validate Terraform configuration.
2. Authenticate with Azure (`azure/login`).
3. Initialize Terraform backend.
4. Run `terraform apply` with `-auto-approve`.


---

### 2. Destroy (Tear Down Infrastructure)

- Workflow: [`.github/workflows/destroy.yml`](.github/workflows/destroy.yml)
- Trigger: **Manual run only** (`workflow_dispatch`)

Inputs:
- `environment` (choice: `dev` or `staging`)

Steps executed:
1. Terraform init for the selected environment.
2. Plan destroy (`terraform plan -destroy`).
3. Apply destroy (`terraform destroy -auto-approve`).

Run manually from GitHub UI:
- Go to **Actions → Terraform Destroy → Run workflow**.
- Choose environment (default: `dev`).
- Trigger the job.

---

## Variables

Values are defined in `terraform.tfvars`:

```hcl
rgname                 = ""
service_principal_name = ""
keyvault_name          = ""
cluster_name           = ""
node_pool_name         = ""
location               = ""
```

Secrets required for workflows (configured in GitHub repo → Settings → Secrets and variables → Actions):

- **ARM_CLIENT_ID** : Your ARM client ID.

- **ARM_CLIENT_SECRET** : Your ARM client secret.

- **ARM_SUBSCRIPTION_ID** :  Your ARM subscription ID.

- **ARM_TENANT_ID** : Your ARM tenant ID.

- **AZURE_CREDENTIALS** : JSON service principal credentials for azure/login

- **GHA_CLIENT_ID** : Github Actioon client ID



---


### Usage Summary

Deploy Infra: Push to main or manually run Terraform Create workflow.

Destroy Infra: Manually run Terraform Destroy workflow and choose environment.

State Management: Stored remotely in Azure Blob Storage (configured in backend.tf).