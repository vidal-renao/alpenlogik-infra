terraform {
  backend "azurerm" {
    resource_group_name  = "rg-alpenlogik-tfstate-chn-001"
    storage_account_name = "stalpenlogiklabtf"
    container_name       = "tfstate"
    key                  = "bootstrap.tfstate"
  }
}
