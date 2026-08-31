resource "azurerm_mssql_database" "db" {
  name      = var.sql_database_name
  server_id = var.sql_server_id
  sku_name  = "S0"
}
