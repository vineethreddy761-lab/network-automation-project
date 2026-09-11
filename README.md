# Network Automation Project

A comprehensive network automation and routing lab environment featuring Docker-based FRR (Free Range Routing) routers, secure IPsec VPN tunnels, multi-cloud BGP peering, and automated CI/CD pipeline provisioning.

## Project Structure
- **configs/**: FRR routing, BGP configuration files, and strongSwan IPsec configurations (`ipsec.conf`, `ipsec.secrets`).
- **scripts/**: Setup and automation scripts.
- **modules/network_peer/**: Terraform modules for network peering.
- **.github/workflows/**: End-to-end CI/CD automation pipelines.
- **docker-compose.yml**: Multi-container topology for `cloud-router` and `telco-router`.
- **Dockerfile.router**: Custom Ubuntu 22.04 container definition with natively compiled FRR and strongSwan.

## Project Phases & Architecture

### Phase 1: Base Topology & Container Infrastructure
* **Environment**: Ubuntu 22.04 container base avoiding capability restrictions.
* **Management Network**: Bridge network `192.168.56.0/24`.
  * `cloud-router`: `192.168.56.10` (AS 65001)
  * `telco-router`: `192.168.56.20` (AS 65002)

### Phase 2: Secure IPsec VPN Tunnel
* **Protocol**: IKEv2 / IPsec (ESP via strongSwan)
* **Authentication**: Pre-Shared Key (PSK)
* **Traffic Selectors**: `10.0.0.0/16 === 10.1.0.0/16`
* **Encryption / Integrity**: AES-CBC-128 / HMAC-SHA2-256-128

### Phase 3: BGP Routing & Verification
* **Dynamic Routing**: BGP peering established across routers.
* **Loopback Subnets**: Advertised and verified via loopback addresses (`10.0.0.1/32` and `10.1.0.1/32`).
* **Validation**: End-to-end encrypted ping testing with 0% packet loss.

## Quick Start & Testing

1. **Build and Start Environment**:
   ```bash
   docker compose up -d --build
docker exec -it cloud-router ipsec status
docker exec -it cloud-router vtysh -c "show ip bgp summary"
