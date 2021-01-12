provider "azurerm"{
    features {      
    }
}

resource "azurerm_resource_group" "default"{
    name        = var.resource_group
    location    = var.location
}

data "azurerm_client_config" "current" {}

resource "azurerm_application_insights" "app_insights" {
  name                = "mlops_batch_score"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  application_type    = "web"
}

resource "azurerm_key_vault" "key_vault" {
  name                = "mlops-batch-score"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

# generate a random suffix for the storage account name
resource "random_string" "storage_account_name" {
    length  = 9
    special = false
    upper   = false
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "mlopsbatchscore${random_string.storage_account_name.result}"
  location                 = azurerm_resource_group.default.location
  resource_group_name      = azurerm_resource_group.default.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_machine_learning_workspace" "ml_workspace" {
  name                    = "mlops_batch_score"
  location                = azurerm_resource_group.default.location
  resource_group_name     = azurerm_resource_group.default.name
  application_insights_id = azurerm_application_insights.app_insights.id
  key_vault_id            = azurerm_key_vault.key_vault.id
  storage_account_id      = azurerm_storage_account.storage_account.id

  identity {
    type = "SystemAssigned"
  }
}

# generate a random suffix for the storage account name
resource "random_string" "data_storage_account_name" {
    length  = 5
    special = false
    upper   = false
}

resource "azurerm_storage_account" "data_storage_account" {
  name                     = "mlopsbatchscoredata${random_string.data_storage_account_name.result}"
  location                 = azurerm_resource_group.default.location
  resource_group_name      = azurerm_resource_group.default.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "data_storage_container" {
  name                    = "data"
  storage_account_name    = azurerm_storage_account.data_storage_account.name
  container_access_type   = "private"  
}