variable "service_name" {
  type = string
}
variable "upstream_url" {
  type = string
}

resource "kong_service" "this" {
  name = var.service_name
  url  = var.upstream_url
}