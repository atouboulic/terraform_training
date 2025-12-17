resource "docker_network" "this" {
  name   = var.network_name
  driver = var.driver

  ipam_config {
    subnet  = var.subnet
    gateway = var.gateway
  }
}