
module "networks" {
  for_each = var.networks
  source   = "../../module/"

  network_name = "${each.key}-network"
  driver       = each.value.driver
  subnet       = each.value.subnet
  gateway      = each.value.gateway


}
