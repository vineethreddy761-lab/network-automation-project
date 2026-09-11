output "peer_info" {
  value = "Configured peer ${terraform_data.peer_simulator.output.name} with ASN ${terraform_data.peer_simulator.output.asn}"
}
