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
  })
  default = {
    id = 1
    env = "training"
    ip  = "172.130.10.11"
    is_master  = false
    internal_port = 3000
    external_port = 9011
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
  })
  default = {
    id = 2
    env = "training"
    ip  = "172.130.10.12"
    is_master  = false
    internal_port = 3000
    external_port = 9012
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
  })
  default = {
    id = 3
    env = "training"
    ip  = "172.130.10.13"
    is_master  = false
    internal_port = 3000
    external_port = 9013
  }
}