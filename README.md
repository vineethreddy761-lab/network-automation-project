# Network Automation Project: Multi-Cloud BGP & IPsec VPN Architecture

An automated multi-router transit environment leveraging **Free Range Routing (FRR)** for BGP dynamic routing and **strongSwan (IKEv2)** for secure IPsec tunnels across Docker containers.

## Project Phases & Architecture

### Phase 1: Base Topology & Container Infrastructure
* **Environment**: Ubuntu 22.04 container base with natively compiled FRR and strongSwan.
* **Management Network**: Bridge network `192.168.56.0/24`.
  * `cloud-router`: `192.168.56.10` (AS 65001)
  * `telco-router`: `192.168.56.20` (AS 65002)

### Phase 2: Secure IPsec VPN Tunnel
* **Protocol**: IKEv2 / IPsec (ESP)
* **Authentication**: Pre-Shared Key (PSK)
* **Traffic Selectors**: `10.0.0.0/16 === 10.1.0.0/16`
* **Encryption / Integrity**: AES-CBC-128 / HMAC-SHA2-256-128

### Phase 3: BGP Routing & Verification
* **Dynamic Routing**: BGP peering established across management interfaces.
* **Loopback Subnets**: Advertised and verified via loopback addresses (`10.0.0.1/32` and `10.1.0.1/32`).
* **Validation**: End-to-end encrypted ping testing with 0% packet loss.

## Quick Start & Testing

1. **Build and Start Environment**:
   ```bash
   docker compose up -d --build
docker exec -it cloud-router ipsec status
docker exec -it cloud-router vtysh -c "show ip bgp summary"
