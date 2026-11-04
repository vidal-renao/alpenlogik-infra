terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-alpenlogik-tfstate-chn-001"
    storage_account_name = "stalpenlogiklabtf"
    container_name       = "tfstate"
    key                  = "lab.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  use_oidc                        = true
}

locals {
  resource_group_name = "rg-alpenlogik-lab-chn-001"
  tags = {
    Environment = "lab"
    Project     = "alpenlogik"
    Owner       = "it"
    ManagedBy   = "terraform"
    DeleteAfter = "2026-11-08"
  }
}

data "azurerm_resource_group" "lab" {
  name = local.resource_group_name
}

resource "azurerm_log_analytics_workspace" "lab" {
  name                = "log-alpenlogik-lab-chn-001"
  resource_group_name = data.azurerm_resource_group.lab.name
  location            = data.azurerm_resource_group.lab.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

resource "azurerm_container_app_environment" "lab" {
  name                       = "cae-alpenlogik-lab-chn-001"
  resource_group_name        = data.azurerm_resource_group.lab.name
  location                   = data.azurerm_resource_group.lab.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lab.id
  tags                       = local.tags
}

resource "azurerm_container_app" "lab" {
  name                         = "ca-alpenlogik-lab-chn-001"
  resource_group_name          = data.azurerm_resource_group.lab.name
  container_app_environment_id = azurerm_container_app_environment.lab.id
  revision_mode                = "Multiple"
  tags                         = local.tags

  template {
    min_replicas    = 0
    max_replicas    = 1
    revision_suffix = var.revision_suffix

    container {
      name   = "web"
      image  = var.container_image
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = var.target_port

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
