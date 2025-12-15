terraform {
  backend "consul" {
    address = "127.0.0.1:8500"
    scheme  = "http"
    path    = "terraform/state/TP02"
    access_token = "a580f842-cfcb-f0f6-4cb6-de22e17c4bcd"
  }
}
