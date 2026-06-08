provider "azurerm" {
  features {}
}

# ✅ Resource Group
module "rg" {
  source = "./modules/resource_group"

  name        = "rg-${var.prefix}-${var.environment}"
  location    = "East US"
  prefix      = var.prefix
  environment = var.environment
}

# ✅ Network
module "network" {
  source = "./modules/network"

  resource_group_name = module.rg.name
  location            = module.rg.location
  environment         = var.environment
  prefix              = var.prefix
}

# ✅ VM
module "vm" {
  source = "./modules/vm"

  resource_group_name = module.rg.name
  location            = module.rg.location

  vm_name        = "vm-${var.prefix}-${var.environment}"
  admin_username = "azureuser"
  admin_password = var.admin_password

  subnet_id   = module.network.subnet_id
  environment = var.environment
  prefix      = var.prefix
}