# Azure DevOps Platform

An end-to-end DevOps project that demonstrates how to provision, secure, containerize, and deploy a cloud-native application on Microsoft Azure using Infrastructure as Code, CI/CD, and GitOps practices.

## Project Overview

This project uses Terraform to provision Azure infrastructure, Docker to containerize the application, GitHub Actions for Continuous Integration, Azure Container Registry (ACR) to store Docker images, Argo CD for GitOps-based Continuous Deployment, and Azure Kubernetes Service (AKS) to run the application.

## Architecture

```text
Developer
   |
   | git push
   v
GitHub Repository
   |
   v
GitHub Actions
   |
   |-- Test / Validate
   |-- Build Docker Image
   |-- Push Image
   v
Azure Container Registry (ACR)
   |
   v
Update Kubernetes Image Tag
   |
   v
GitOps Repository
   |
   v
Argo CD
   |
   v
Azure Kubernetes Service (AKS)
   |
   |-- Deployment
   |-- Multiple Pods
   |-- Service
   |-- Ingress / LoadBalancer
   |-- Health Probes
   |-- HPA
   |-- PDB
   |
   v
Azure Database for PostgreSQL

Secrets
   |
   v
Azure Key Vault
```

## DevOps Flow

1. The developer pushes application changes to GitHub.
2. GitHub Actions automatically starts the CI workflow.
3. The pipeline validates the application and builds a Docker image.
4. The image is pushed to Azure Container Registry.
5. The Kubernetes manifest is updated with the new image version.
6. Argo CD detects the change in the GitOps repository.
7. Argo CD synchronizes the desired state with AKS.
8. AKS pulls the new image from ACR and performs the deployment.
9. Kubernetes manages application replicas, health checks, scaling, and availability.

## Technologies Used

- Microsoft Azure
- Terraform
- Docker
- Kubernetes
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure Key Vault
- Azure Database for PostgreSQL
- GitHub Actions
- Argo CD
- Git / GitHub

## Infrastructure as Code

Terraform is used to provision the Azure infrastructure, including:

- Resource Group
- Virtual Network
- Subnets
- Azure Container Registry
- Azure Kubernetes Service
- Azure Key Vault
- Azure Database for PostgreSQL

Using Infrastructure as Code makes the environment repeatable, version-controlled, and easier to maintain.

## Containerization

The application is packaged with its dependencies into a Docker image.

This provides:

- Consistent execution across environments
- Portability
- Dependency isolation
- Faster deployments
- Easy integration with Kubernetes

The image is stored in Azure Container Registry and later pulled by AKS during deployment.

## Continuous Integration with GitHub Actions

GitHub Actions handles the CI process.

Typical pipeline flow:

```text
Checkout Code
     |
     v
Test / Validate
     |
     v
Build Docker Image
     |
     v
Login to Azure / ACR
     |
     v
Push Docker Image
     |
     v
Update Kubernetes Image Tag
```

This removes the need for manual image builds and deployments.

## GitOps with Argo CD

Argo CD continuously watches the Kubernetes manifests stored in Git.

When GitHub Actions updates the application image tag, Argo CD detects the change and synchronizes it with the AKS cluster.

```text
GitHub Actions
      |
      v
GitOps Repository
      |
      v
Argo CD
      |
      v
AKS
```

This keeps Git as the source of truth for the Kubernetes environment.

## Security

The platform follows several security practices:

- Secrets are kept outside the application code.
- Azure Key Vault is used for sensitive configuration and credentials.
- PostgreSQL can be placed behind private networking.
- AKS accesses container images from ACR instead of public registries.
- Infrastructure configuration is version-controlled through Terraform.
- CI/CD credentials should be stored securely using GitHub Actions Secrets or Azure authentication mechanisms.
- Application containers run from immutable Docker images.

## High Availability

High availability is supported at the application level using Kubernetes features such as:

- Multiple application replicas
- Liveness probes
- Readiness probes
- Horizontal Pod Autoscaler (HPA)
- Pod Disruption Budget (PDB)
- Kubernetes Services for traffic distribution

> Note: Full infrastructure-level high availability requires multiple AKS worker nodes, preferably distributed across Availability Zones. A single-node development cluster does not provide full node-level high availability.

## Health Checks

The application exposes health endpoints such as:

```text
/health
/ready
```

These endpoints are used by Kubernetes probes to determine whether the application is alive and ready to receive traffic.

## Suggested Repository Structure

```text
.
├── app/
│   ├── Dockerfile
│   └── ...
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── providers.tf
├── k8s/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── hpa.yaml
│   └── pdb.yaml
├── .github/
│   └── workflows/
│       └── ci.yml
└── README.md
```

## Deployment Summary

```text
Terraform
   |
   v
Azure Infrastructure
   |
   v
Dockerized Application
   |
   v
GitHub Actions
   |
   v
Azure Container Registry
   |
   v
GitOps Repository
   |
   v
Argo CD
   |
   v
AKS
   |
   v
PostgreSQL + Key Vault
```

## Key DevOps Concepts Demonstrated

- Infrastructure as Code
- Containerization
- Continuous Integration
- GitOps
- Continuous Deployment
- Kubernetes orchestration
- Secrets management
- Cloud networking
- Application scalability
- High availability
- Automated deployments

## Author

**Mustafa Mohamed**  
DevOps & Cloud Engineer
# az-end-to-end-devops
