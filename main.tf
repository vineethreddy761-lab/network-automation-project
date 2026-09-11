terraform {
  required_version = ">= 1.0.0"
}

provider "external" {}

data "external" "ipam_config" {
  program = ["python3", "${path.module}/scripts/custom_ipam.py"]
  query = {
    environment = "lab"
  }
}

module "cloud_peer" {
  source    = "./modules/network_peer"
  peer_name = "cloud-router"
  asn       = data.external.ipam_config.result.local_asn
}

module "telco_peer" {
  source    = "./modules/network_peer"
  peer_name = "telco-router"
  asn       = data.external.ipam_config.result.remote_asn
}

output "deployment_summary" {
  value = {
    cloud_status = module.cloud_peer.peer_info
    telco_status = module.telco_peer.peer_info
    tunnel_ip    = data.external.ipam_config.result.tunnel_subnet
  }
}
