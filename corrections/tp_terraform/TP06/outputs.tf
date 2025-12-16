# 1. Output principal : Le nom du réseau et son ID
output "network_summary" {
  description = "Résumé des informations de base du réseau Docker."
  value = {
    Name   = data.docker_network.tp_terraform.name
    ID     = data.docker_network.tp_terraform.id
    Driver = data.docker_network.tp_terraform.driver
    Ipam   = data.docker_network.tp_terraform.ipam_config
  }
}

output "container_spec_summary" {
  description = "Résumé des informations de base sur les containers."
  value       = local.containers
}

# 2. Détails IPAM (Subnets)
# Nous utilisons la fonction join et for_each pour présenter clairement les sous-réseaux et les passerelles.
output "network_ipam_details" {
  description = "Détails de l'adressage IP (IPAM) pour chaque sous-réseau."

  value = join("\n", [
    for ipam in data.docker_network.tp_terraform.ipam_config : format(
      "  => Subnet: %s, Gateway: %s, IP Range: %s",
      ipam.subnet,
      ipam.gateway,
      ipam.ip_range
    )
  ])
}