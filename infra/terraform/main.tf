terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "trustledger" {
  name     = "rg-trustledger"
  location = "East US"
}

resource "azurerm_key_vault" "issuer_keys" {
  name                = "kv-trustledger-issuer"
  location            = azurerm_resource_group.trustledger.location
  resource_group_name = azurerm_resource_group.trustledger.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]
  }
}

resource "azurerm_container_app_environment" "trustledger" {
  name                = "cae-trustledger"
  location            = azurerm_resource_group.trustledger.location
  resource_group_name = azurerm_resource_group.trustledger.name
}

resource "azurerm_container_app" "api_gateway" {
  name                         = "ca-trustledger-api"
  container_app_environment_id = azurerm_container_app_environment.trustledger.id
  resource_group_name          = azurerm_resource_group.trustledger.name
  revision_mode                = "Single"

  template {
    container {
      name   = "api-gateway"
      image  = "trustledger/api-gateway:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "AZURE_KEY_VAULT_URL"
        value = azurerm_key_vault.issuer_keys.vault_uri
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 3000
    traffic_weight {
      percentage = 100
    }
  }
}

resource "azurerm_application_insights" "trustledger" {
  name                = "appi-trustledger"
  location            = azurerm_resource_group.trustledger.location
  resource_group_name = azurerm_resource_group.trustledger.name
  application_type    = "web"
}

data "azurerm_client_config" "current" {}