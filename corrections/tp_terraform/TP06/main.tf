data "docker_network" "tp_terraform" {
  name = var.docker_network_name
}

locals {
  containers = {
    "goapi01" = var.goapi01,
    "goapi02" = var.goapi02,
    "goapi03" = var.goapi03
  }
}

# --- Conteneur GOAPI-masters ---
resource "docker_container" "goapi_masters" {
  for_each = { for name, config in local.containers : name => config
    if config.is_master
  }
  name  = "GOAPI-${each.value.id}" #interpolation HCL ${var....}
  image = var.docker_image

  lifecycle {
    prevent_destroy = true
  }

  ports {
    internal = each.value.internal_port
    external = each.value.external_port
  }

  env = [
    "ENV=${each.value.env}",
    "IS_MASTER=${each.value.is_master}",
    "CONTAINER_IP=${each.value.ip}",
    "LISTEN_PORT=${each.value.internal_port}"
  ]

  dynamic "labels" {
    for_each = each.value.labels
    iterator = label
    content {
      label = label.key
      value = label.value
    }
  }
  networks_advanced {
    name         = data.docker_network.tp_terraform.name
    ipv4_address = each.value.ip
  }
}

# --- Conteneur GOAPI  ---

resource "docker_container" "goapi" {
  for_each = { for name, config in local.containers : name => config
    if !config.is_master
  }
  name  = "GOAPI-${each.value.id}" #interpolation HCL ${var....}
  image = var.docker_image

  lifecycle {
    # Bloquer la destruction via precondition
    precondition {
      condition     = !(each.value.labels.type == "slave" && each.value.labels.statut == "optional")
      error_message = "Ce container ne doit pas être construit. (car label type=slave ET un label statut=optional)"
    }
  }

  ports {
    internal = each.value.internal_port
    external = each.value.external_port
  }

  env = [
    "ENV=${each.value.env}",
    "IS_MASTER=${each.value.is_master}",
    "CONTAINER_IP=${each.value.ip}",
    "LISTEN_PORT=${each.value.internal_port}"
  ]

  dynamic "labels" {
    for_each = each.value.labels
    iterator = label
    content {
      label = label.key
      value = label.value
    }
  }
  networks_advanced {
    name         = data.docker_network.tp_terraform.name
    ipv4_address = each.value.ip
  }
}


