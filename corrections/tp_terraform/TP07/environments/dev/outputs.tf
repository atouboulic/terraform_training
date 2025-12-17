output "network_ids" {
  value = {
    for k, net in module.networks : net.network_name => net.network_id
  }
}

##
# module.networks = {
#   "api" = {
#     "network_id" = "271638f9aa2bae164c5b80331c38b82825deba5d488b11db31e2b5cecb79e168"
#     "network_name" = "api-network"
#   }
#   "db" = {
#     "network_id" = "554b134f74f32f271b535e9572b6d272d44da33b6f65bed1002505905f26dd60"
#     "network_name" = "db-network"
#   }
#   "web" = {
#     "network_id" = "3b60fb5f6ef7829e4e75a43723fa43d806751a9c6dc0cb8a5bf7b4dd332d0694"
#     "network_name" = "web-network"
#   }
# }
