provider "azurerm" {
  # version = ">2.4.0"
  #subscription_id = var.subscription_id
  #client_id       = var.client_id 
  #client_secret   = var.client_secret  
  #tenant_id       = var.tenant_id
  features {}
}

variable "res_group_name" {
  type = string
  default = "terraform"
}

resource "azurerm_resource_group" "rg" {
  name     = var.res_group_name
  location = "West Europe"
}

module "vnet" {
  source = "Azure/vnet/azurerm"
  resource_group_name = var.res_group_name
  address_space = ["10.0.0.0/16"]
  subnet_prefixes=["10.0.1.0/24"]
  subnet_names=["database"]
  vnet_name="test_vnet"
  depends_on = [ azurerm_resource_group.rg]
}

resource "azurerm_app_service_plan" "service-plan" {
  name = "ranjitnaik008"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind = "Linux"
  reserved = true
  sku {
    tier = "Basic"
    size = "B1"
  }
  tags = {
    environment = "production"
  }
}

resource "azurerm_app_service" "app-service" {
  name = "ranjitnaik008"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.service-plan.id
  site_config {
    linux_fx_version = "DOTNETCORE|3.1"
  }
  tags = {
    environment = var.environment
  }
  auth_settings {
    
  }
}

resource "azurerm_storage_account" "storage_acc" {
  name                     = "myteststorageacc9100"
  resource_group_name      =  azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "development"
  }
}

resource "azurerm_function_app" "function-app" {
  name                       = "mytestfunctionapp9100"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.service-plan.id
  storage_account_name       = azurerm_storage_account.storage_acc.name
  storage_account_access_key = azurerm_storage_account.storage_acc.primary_access_key
}