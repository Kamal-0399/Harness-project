variable "service_id" {
  type = string
}
variable "paths" {
  type = list(string)
}

resource "kong_route" "this" {
  service_id = var.service_id
  paths      = var.paths
}