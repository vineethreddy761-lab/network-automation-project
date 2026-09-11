resource "terraform_data" "peer_simulator" {
  input = {
    name = var.peer_name
    asn  = var.asn
  }
}
