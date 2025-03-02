provider &quot;azurerm&quot; {
features {}
}
resource &quot;azurerm_resource_group&quot; &quot;webapp_rg&quot; {

name = &quot;webapp-resource-group&quot;
location = &quot;East US&quot;
}
resource &quot;azurerm_container_registry&quot; &quot;acr&quot; {
name = &quot;webappacr&quot;
resource_group_name = azurerm_resource_group.webapp_rg.name
location = azurerm_resource_group.webapp_rg.location
sku = &quot;Basic&quot;
admin_enabled = true
}
resource &quot;azurerm_app_service_plan&quot; &quot;app_service_plan&quot; {
name = &quot;webapp-plan&quot;
location = azurerm_resource_group.webapp_rg.location
resource_group_name = azurerm_resource_group.webapp_rg.name
kind = &quot;Linux&quot;
reserved = true
sku {
tier = &quot;Basic&quot;
size = &quot;B1&quot;
}
}
resource &quot;azurerm_app_service&quot; &quot;webapp&quot; {
name = &quot;webapp-service&quot;
location = azurerm_resource_group.webapp_rg.location
resource_group_name = azurerm_resource_group.webapp_rg.name
app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
site_config {
linux_fx_version = &quot;DOCKER|webappacr.azurecr.io/webapp:latest&quot;
}
identity {
type = &quot;SystemAssigned&quot;
}
depends_on = [azurerm_container_registry.acr]
}