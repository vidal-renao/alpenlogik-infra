output "resource_group_name" {
  value = azurerm_resource_group.state.name
}

output "storage_account_name" {
  value = azurerm_storage_account.state.name
}

output "container_name" {
  value = azurerm_storage_container.state.name
}

output "plan_client_id" {
  value = azurerm_user_assigned_identity.plan.client_id
}

output "apply_client_id" {
  value = azurerm_user_assigned_identity.apply.client_id
}
