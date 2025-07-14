variable "environment" {
  type = string
}

variable "kong_admin_url" {
  type = string
}

variable "kong_cp_id" {
  type = string
}

variable "service_suffix" {
  type = string
  default = ""
}

provider "kong" {
  kong_admin_uri = var.kong_admin_url
}

locals {
  services = jsondecode(file("${path.module}/services.json"))
}

module "services" {
  source = "./modules/service"

  for_each     = local.services
  service_name = "${each.value.service_name}${var.service_suffix}"
  upstream_url = each.value.upstream_url
}

module "routes" {
  source = "./modules/route"

  for_each   = local.services
  service_id = module.services[each.key].id
  paths      = each.value.routes
}

module "plugins" {
  source = "./modules/plugin"

  for_each = {
    for svc_key, svc in local.services :
    "${svc_key}-${svc.plugins[0].name}" => {
      service_id  = module.services[svc_key].id
      plugin_name = svc.plugins[0].name
      config      = svc.plugins[0].config
    }
    if length(svc.plugins) > 0
  }

  service_id  = each.value.service_id
  plugin_name = each.value.plugin_name
  config      = each.value.config
}