resource "azurerm_resource_group" "rg" {
  name     = "example-${var.environment}-rg"
  location = var.location
}

resource "azurerm_service_plan" "asp" {
  name                = "asp-${var.environment}-basic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "app-example-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id
  https_only          = true

  site_config {
    application_stack {
      docker_registry_url = "https://${var.REGISTRY_NAME}.azurecr.io"
      docker_image_name   = "${var.IMAGE_NAME}:${var.IMAGE_TAG}"
    }
    always_on                         = true
    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 2
  }

  app_settings = {
    "DOCKER_ENABLE_CI"  = "true"
    "PORT"              = "8080"
    "WEBSITES_PORT"     = "8080"
    "FORCE_REDEPLOY"    = timestamp()
  }

  identity {
    type = "SystemAssigned"
  }
}
