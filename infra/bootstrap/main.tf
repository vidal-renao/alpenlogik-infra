terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  tags = {
    Environment = "lab"
    Project     = "alpenlogik"
    Owner       = "it"
    ManagedBy   = "terraform"
    DeleteAfter = "2026-11-08"
  }
}

resource "azurerm_resource_group" "state" {
  name     = "rg-alpenlogik-tfstate-chn-001"
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "state" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.state.name
  location                        = azurerm_resource_group.state.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = local.tags
}

resource "azurerm_storage_container" "state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}

resource "azurerm_resource_group" "lab" {
  name     = "rg-alpenlogik-lab-chn-001"
  location = var.location
  tags     = local.tags
}

resource "azurerm_user_assigned_identity" "plan" {
  name                = "id-alpenlogik-plan-chn-001"
  resource_group_name = azurerm_resource_group.state.name
  location            = azurerm_resource_group.state.location
  tags                = local.tags
}

resource "azurerm_user_assigned_identity" "apply" {
  name                = "id-alpenlogik-apply-chn-001"
  resource_group_name = azurerm_resource_group.state.name
  location            = azurerm_resource_group.state.location
  tags                = local.tags
}

resource "azurerm_federated_identity_credential" "plan" {
  name                = "github-pull-request"
  resource_group_name = azurerm_resource_group.state.name
  parent_id           = azurerm_user_assigned_identity.plan.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:${var.github_repository}:pull_request"
}

resource "azurerm_federated_identity_credential" "apply" {
  name                = "github-environment-lab"
  resource_group_name = azurerm_resource_group.state.name
  parent_id           = azurerm_user_assigned_identity.apply.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:${var.github_repository}:environment:lab"
}

resource "azurerm_role_assignment" "plan_reader" {
  scope                = azurerm_resource_group.lab.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.plan.principal_id
}

resource "azurerm_role_assignment" "apply_contributor" {
  scope                = azurerm_resource_group.lab.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.apply.principal_id
}

resource "azurerm_role_assignment" "plan_state" {
  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.plan.principal_id
}

resource "azurerm_role_assignment" "apply_state" {
  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.apply.principal_id
}
