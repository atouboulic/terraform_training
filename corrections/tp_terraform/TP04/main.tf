data "docker_network" "tp_terraform" {
  name = var.docker_network_name
}

locals {
  containers = tomap({
    "goapi1" = var.goapi01,
    "goapi2" = var.goapi02,
    "goapi3" = var.goapi03
  })
}

# --- Conteneur GOAPI-1 ---
resource "docker_container" "goapi1" {
  name  = "GOAPI-${var.goapi01.id}"     #interpolation HCL ${var....}
  image = var.docker_image

  ports {
    internal = var.goapi01.internal_port
    external = var.goapi01.external_port
  }

  env = [
    "ENV=${var.goapi01.env}",
    "IS_MASTER=${var.goapi01.is_master}",
    "CONTAINER_IP=${var.goapi01.ip}",
    "LISTEN_PORT=${var.goapi01.internal_port}"
  ]

  networks_advanced {
    name          = data.docker_network.tp_terraform.name
    ipv4_address  = var.goapi01.ip
  }
}

# --- Conteneur GOAPI-2 ---
resource "docker_container" "goapi2" {
  name  = "GOAPI-${var.goapi02.id}"     #interpolation HCL ${var....}
  image = var.docker_image

  ports {
    internal = var.goapi02.internal_port
    external = var.goapi02.external_port
  }

  env = [
    "ENV=${var.goapi02.env}",
    "IS_MASTER=${var.goapi02.is_master}",
    "CONTAINER_IP=${var.goapi02.ip}",
    "LISTEN_PORT=${var.goapi02.internal_port}"
  ]

  networks_advanced {
    name          = data.docker_network.tp_terraform.name
    ipv4_address  = var.goapi02.ip
  }
}

# --- Conteneur GOAPI-3 ---
resource "docker_container" "goapi3" {
  name  = "GOAPI-${var.goapi03.id}"     #interpolation HCL ${var....}
  image = var.docker_image

  ports {
    internal = var.goapi03.internal_port
    external = var.goapi03.external_port
  }

  env = [
    "ENV=${var.goapi03.env}",
    "IS_MASTER=${var.goapi03.is_master}",
    "CONTAINER_IP=${var.goapi03.ip}",
    "LISTEN_PORT=${var.goapi03.internal_port}"
  ]

  networks_advanced {
    name          = data.docker_network.tp_terraform.name
    ipv4_address  = var.goapi03.ip
  }
}