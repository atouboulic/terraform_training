# FICHIER: variables.tf

# 1. Variable primitive pour le nom du réseau existant (réutilisé)
variable "docker_network_name" {
  description = "Nom du réseau Docker existant à utiliser."
  type        = string
  default     = "tp_terraform_network"
}

# 2. Variable primitive pour l'image Docker (commune aux trois conteneurs)
variable "docker_image" {
  description = "Nom de l'image Docker à utiliser pour tous les conteneurs."
  type        = string
  default     = "goapi:latest"
}



variable "goapi01" {
  description = "specs goapi01"
  type = object({
    id            = number
    env           = string
    ip            = string
    is_master     = bool    # Booléen
    internal_port = number  # Nombre
    external_port = number  # Nombre
    labels        = map(string)
  })
  default = {
    id = 1
    env = "training"
    ip  = "172.130.10.11"
    is_master  = false
    internal_port = 3000
    external_port = 9011
    labels = {
      type = "master"
      statut = "mandatory"
    }
  }
}

variable "goapi02" {
  description = "specs goapi02"
  type = object({
    id            = number
    env           = string
    ip            = string
    is_master     = bool    # Booléen
    internal_port = number  # Nombre
    external_port = number  # Nombre
    labels        = map(string)
  })
  default = {
    id = 2
    env = "training"
    ip  = "172.130.10.12"
    is_master  = false
    internal_port = 3000
    external_port = 9012
    labels = {
      type = "slave"
      statut = "mandatory"
    }
  }
}

variable "goapi03" {
  description = "specs goapi03"
  type = object({
    id            = number
    env           = string
    ip            = string
    is_master     = bool    # Booléen
    internal_port = number  # Nombre
    external_port = number  # Nombre
    labels        = map(string)
  })
  default = {
    id = 3
    env = "training"
    ip  = "172.130.10.13"
    is_master  = false
    internal_port = 3000
    external_port = 9013
    labels = {
     type = "slave"
     statut = "optional"
    }
  }
}
# 3. Variable Map complexe pour les configurations spécifiques de chaque conteneur
# La clé de la Map (e.g., "app_a") sera utilisée pour nommer la ressource.
variable "conteneur_specs" {
  description = "Détails de configuration pour chaque conteneur."
  type = map(object({
    env = string
    ip  = string
    is_master  = bool
    internal_port = number
    external_port = number
  }))

  default = {
    # Configuration du Conteneur A
    goapi01 = {
      env = "training"
      ip  = "172.130.10.11"
      is_master  = false
      internal_port = 3000
      external_port = 9011
    }
    # Configuration du Conteneur B
    goapi02 = {
      env = "training"
      ip  = "172.130.10.12"
      is_master  = false
      internal_port = 3000
      external_port = 9012
    }
    # Configuration du Conteneur C
    goapi03 = {
      env = "training"
      ip  = "172.130.10.13"
      is_master  = false
      internal_port = 3000
      external_port = 9013
    }
  }
}
