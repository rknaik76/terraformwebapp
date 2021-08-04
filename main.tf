provider "azurerm" {
  # version = ">2.4.0"
  #subscription_id = var.subscription_id
  #client_id       = var.client_id 
  #client_secret   = var.client_secret  
  #tenant_id       = var.tenant_id
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "azure-functions-test-rg"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "mytestfunction9191"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example" {
  name                = "mytestfunction019191"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "example" {
  name                       = "mytestfunction029191"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
}