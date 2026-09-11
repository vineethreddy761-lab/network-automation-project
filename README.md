Network Automation Lab: Multi-Cloud BGP, IPsec VPN & Monitoring Architecture

This repository contains a fully automated, production-grade network automation laboratory simulating a multi-site transit environment using **Free Range Routing (FRR)**, **strongSwan (IKEv2)**, and **Prometheus**.

## Project Overview & Architecture
* **Cloud Router (`cloud-router`)**: AS 65001, Management IP `192.168.56.10`, Loopback `10.0.0.1/32`.
* **Telco Router (`telco-router`)**: AS 65002, Management IP `192.168.56.20`, Loopback `10.1.0.1/32`.
* **Encrypted Transit**: IKEv2 / IPsec (ESP) tunnel (`net-to-net`) utilizing AES-CBC-128 and HMAC-SHA2-256.
* **Observability**: Prometheus metrics collection integrated via an isolated bridge network (`net-mgmt`).

---

## Implementation Phases

### Phase 1: Base Container Infrastructure
* Custom Ubuntu 22.04 Docker container (`Dockerfile.router`) compiling and provisioning networking toolsets.
* Configured isolated Docker bridge network (`192.168.56.0/24`) with explicit static IP allocations.

### Phase 2: Secure IPsec VPN Tunnel
* Deployed strongSwan IKEv2 daemons with Pre-Shared Key (PSK) authentication.
* Established secure Child Security Associations protecting inter-site traffic.

### Phase 3: BGP Dynamic Routing & Validation
* Configured FRR BGP peering between AS 65001 and AS 65002.
* Verified stable route exchange of loopback subnets across the encrypted tunnel.

### Phase 4: Monitoring & Observability
* Integrated **Prometheus** for telemetry tracking and service target health monitoring.

---

## Usage & Execution
1. **Start the Stack**:
   ```bash
   docker compose up -d --build```
2. **Verify BGP Peering**:

  ```Bash
  docker exec -it cloud-router vtysh -c "show ip bgp summary" ```
3. **Verify IPsec Status**:

  ```Bash
  docker exec -it cloud-router ipsec statusall ```
