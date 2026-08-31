module "rg" {
  source = "../modules/azurerm_resource_group"
  resource_group_name = "rg-todo"
  location            = "centralindia"
}

module "vnet" {
  source = "../modules/azurerm_virtual_network"
  resource_group_name = module.rg.rg_name
  location            = module.rg.rg_location
  virtual_network_name = "vnet-todo"
  address_space        = ["192.168.0.0/16"]
}

module "frontend_subnet" {
  source = "../modules/azurerm_subnets"
  resource_group_name  = module.rg.rg_name
  virtual_network_name = module.vnet.vnet_name
  subnet_name          = "frontend-subnet"
  address_prefixes     = ["192.168.1.0/24"]
}

module "backend_subnet" {
  source = "../modules/azurerm_subnets"
  resource_group_name  = module.rg.rg_name
  virtual_network_name = module.vnet.vnet_name
  subnet_name          = "backend-subnet"
  address_prefixes     = ["192.168.2.0/24"]
}

module "frontend_public_ip" {
  source              = "../modules/azurerm_public_ip"
  resource_group_name = module.rg.rg_name
  location            = module.rg.rg_location
  public_ip_name      = "frontend-pip"
}

module "backend_public_ip" {
  source              = "../modules/azurerm_public_ip"
  resource_group_name = module.rg.rg_name
  location            = module.rg.rg_location
  public_ip_name      = "backend-pip"
}

module "frontend_vm" {
  source = "../modules/azurerm_virtual_machine"
  resource_group_name = module.rg.rg_name
  location            = module.rg.rg_location
  vm_name   = "frontend-vm"
  vm_size   = "Standard_D2s_v3"
  admin_username = "ranjeet"
  admin_password = "Admin@123"
  public_ip_id    = module.frontend_public_ip.public_ip_id
  subnet_id       = module.frontend_subnet.subnet_id
  custom_data = filebase64("${path.module}/frontend.sh")
 
}

module "backend_vm" {
  source = "../modules/azurerm_virtual_machine"
  resource_group_name = module.rg.rg_name
  location            = module.rg.rg_location
  vm_name   = "backend-vm"
  vm_size   = "Standard_D2s_v5"
  admin_username = "ranjeet"
  admin_password = "Admin@123"
  public_ip_id    = module.backend_public_ip.public_ip_id
  subnet_id       = module.backend_subnet.subnet_id
  custom_data = filebase64("${path.module}/backend.sh")
}

module "sql_server" {
  source = "../modules/azure_sql_server"
  resource_group_name = module.rg.rg_name
  location            = module.rg.rg_location
  sql_server_name     = "tododbserver"
  administrator_login = "sqladmin"
  administrator_password = "Admin@123"
}

module "sql_database" {
  source           = "../modules/azure_sql_database"
  sql_server_id    = module.sql_server.sql_server_id
  sql_database_name = "todo_db"
}
