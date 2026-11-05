output "app_url" {
  value = "https://${azurerm_container_app.lab.ingress[0].fqdn}"
}
