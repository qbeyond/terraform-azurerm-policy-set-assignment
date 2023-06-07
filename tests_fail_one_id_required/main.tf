provider "azurerm" {
  features {
  }
}

resource "random_pet" "this" {
  separator = ""
  length = 1
  prefix = "PolicyAssignment"
}

resource "azurerm_resource_group" "this" {
  name     = "rg-dev-${random_pet.this.id}-01"
  location = "West Europe"
}

data "azurerm_policy_definition" "this" {
  display_name = "Audit usage of custom RBAC roles"
}

data "azurerm_policy_set_definition" "this" {
  display_name = "Deploy prerequisites to enable Guest Configuration policies on virtual machines"
}

module "no_ids_policy_assignment_resource_group" {
  source = "./.."
  scope = azurerm_resource_group.this.id
  location = azurerm_resource_group.this.location
}

module "both_ids_policy_assignment_resource_group" {
  source = "./.."
  scope = azurerm_resource_group.this.id
  location = azurerm_resource_group.this.location
  policy_definition_id = data.azurerm_policy_definition.this.id
  policy_set_definition_id = data.azurerm_policy_set_definition.this.id
}