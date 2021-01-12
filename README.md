# Azure MLOps Batch Scoring

## Features

* Uses Development Containers to control local development environment and dependencies
* Uses Terraform to control infrastructure as code
* Uses Azure DevOps to build, test and deploy code
* Uses Azure Machine Learning to train, package, validate and deploy models

## Getting Started

Run the terraform scripts to setup the azure infrastructure

```bash
cd src/terraform
az login
# target the appropriate subscription with `az account set`
terraform plan
terraform apply -auto-approve
```

Copy the data files to azure blob storage

```bash
cd src/scripts
./copy-data.sh
```

