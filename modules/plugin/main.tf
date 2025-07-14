variable "plugin_name" {
  type = string
}
variable "config" {
  type = map(any)
  default = {}
}
variable "service_id" {
  type = string
}

resource "kong_plugin" "this" {
  name       = var.plugin_name
  config     = var.config
  service_id = var.service_id
}