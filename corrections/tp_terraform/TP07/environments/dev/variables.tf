variable "networks" {
  default = {
    web = {
      driver  = "bridge"
      subnet  = "172.210.0.0/16"
      gateway = "172.210.0.1"
    }
    api = {
      driver  = "bridge"
      subnet  = "172.211.0.0/16"
      gateway = "172.211.0.1"
    }
    db = {
      driver  = "bridge"
      subnet  = "172.212.0.0/16"
      gateway = "172.212.0.1"
    }
  }
}