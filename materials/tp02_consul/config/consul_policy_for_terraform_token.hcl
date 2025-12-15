# 1. PERMISSION DE SESSION (OBLIGATOIRE POUR LE VERROUILLAGE D'ÉTAT)
# 'write' sur session permet au jeton de créer, renouveler et détruire ses propres sessions.
session "" {
  policy = "write"
}

# Nécessaire pour les opérations de planification et d'application
session_prefix "" {
  policy = "write"
}

# Accorder des permissions de lecture, écriture et suppression (write) sur le chemin KV pour l'état Terraform.
# La permission 'write' dans Consul couvre la création, la mise à jour et la suppression.
key_prefix "terraform/state/" {
  policy = "write"
}

# IMPORTANT : Refuser l'accès au chemin 'consul/acl' pour éviter que le token puisse modifier les politiques ou ACLs.
# La politique par défaut de Consul refuse l'accès si non spécifié, mais il est toujours bien de l'expliciter si le jeton hérite d'autres droits.
key_prefix "consul/acl/" {
  policy = "deny"
}

# Autoriser la lecture du chemin par défaut de Consul (souvent nécessaire pour le fonctionnement interne de Terraform)
key_prefix "" {
  policy = "read"
}