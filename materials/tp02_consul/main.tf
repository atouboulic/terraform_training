# 1. Déclaration du réseau interne pour Consul (si nécessaire pour d'autres conteneurs)
resource "docker_network" "consul_network" {
  name = "consul-acl-net"
  driver = "bridge"
}

# 2. Déclaration d'un volume persistant (très important pour les données de Consul)
resource "docker_volume" "consul_data" {
  name = "dev_consul_data"
}

# 3. Déclaration de l'image (Terraform va la puller si elle n'est pas là)
resource "docker_image" "consul_image" {
  name = "hashicorp/consul:1.22"
  keep_locally = true
}

locals {
  # Définition de la configuration ACL en HCL
  consul_acl_config = {
    acl = {
      enabled        = true
      default_policy = "deny"
      down_policy    = "extend-cache"
      tokens = {
        master = "votre-token-master-secret"
      }
    }
  }
}

# 4. Déclaration du conteneur Consul
resource "docker_container" "dev_consul" {
  name  = "dev-consul-tf"
  image = docker_image.consul_image.name

  # La commande pour démarrer Consul en mode dev et lui indiquer l'adresse client
  command = [
    "agent",
    "-dev",
    "-bootstrap",
    "-ui",
    "-client=0.0.0.0",
    # -data-dir est indispensable pour que le mode non-dev puisse écrire l'état
    "-data-dir=/consul/data",
    "-config-dir=/consul/config"
  ]

  # Monter le volume de données (état de Consul)
  volumes {
    volume_name = docker_volume.consul_data.name
    container_path = "/consul/data"
  }

  # Mapping des ports pour l'accès externe et l'UI
  ports {
    internal = 8500
    external = 8500
  }

  # Joindre le conteneur au réseau créé
  networks_advanced {
    name = docker_network.consul_network.name
  }

  # Définir les variables d'environnement (selon votre besoin)
  env = [
    "CONSUL_BIND_INTERFACE=eth0",

    # INJECTION DU JSON ACL COMPLET
    "CONSUL_LOCAL_CONFIG=${jsonencode(local.consul_acl_config)}"
  ]
}

# 5. Output (pour confirmer que le service est disponible)
output "consul_access_url" {
  value = "http://localhost:${docker_container.dev_consul.ports[0].external}"
}