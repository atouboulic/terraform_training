terraform {
  backend "consul" {
    address = "127.0.0.1:8500"
    scheme  = "http"
    path    = "terraform/state/TP07"
    access_token = "ec80e245-1262-66d8-0be3-e99538f46d9d"
  }
}
