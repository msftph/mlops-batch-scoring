output "data_storage_account_name"{
    value = azurerm_storage_account.data_storage_account.name
}

output "data_storage_account_connection_string"{
    value = azurerm_storage_account.data_storage_account.primary_connection_string
}