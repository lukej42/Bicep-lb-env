# Azure Load Balancer Deployment with Bicep

This repository contains Bicep templates to deploy an **Azure Load Balancer environment** with multiple virtual machines, a virtual network, and optional integration with Azure resources like Key Vault and App Services.

---

## Project Structure
infrastructure/
├─ main.bicep                  # Entry point Bicep template
├─ parameters/
│  ├─ parameters.dev.json      # Development parameters
│  └─ parameters.prod.json     # Production parameters
└─ modules/
├─ vm.bicep                 # Virtual machine module
├─ loadbalancer.bicep       # Load balancer module
├─ storage.bicep            # Storage account module
└─ keyvault.bicep           # Key Vault module

---

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- [Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install)
- An Azure subscription
- PowerShell, Bash, or compatible shell

---

## Deployment

### Deploy to a Resource Group

**Development environment:**

```bash
az deployment group create \
  --resource-group <your-resource-group> \
  --template-file main.bicep \
  --parameters @parameters/parameters.dev.json# Bicep-lb-env
# Bicep-lb-env
# Bicep-lb-env
