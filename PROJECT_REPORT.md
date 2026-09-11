# Network Automation Project: Multi-Cloud BGP, IPsec VPN & Monitoring Architecture

## 1. Executive Summary
This project successfully establishes a secure, automated multi-router transit environment using **Free Range Routing (FRR)** for BGP dynamic routing, **strongSwan (IKEv2)** for IPsec encryption, and **Prometheus** for service observability over a simulated multi-site topology. The implementation spans four core phases: container infrastructure provisioning (Phase 1), secure IPsec VPN tunnel establishment (Phase 2), BGP dynamic routing validation (Phase 3), and monitoring integration (Phase 4).

## 2. Architecture & Topology
* **Cloud Router (`cloud-router`)**:
  * Management IP: `192.168.56.10`
  * BGP Autonomous System: `65001`
  * Loopback / Advertised Subnet: `10.0.0.1/32`
* **Telco Router (`telco-router`)**:
  * Management IP: `192.168.56.20`
  * BGP Autonomous System: `65002`
  * Loopback / Advertised Subnet: `10.1.0.1/32`
* **IPsec VPN Tunnel (`net-to-net`)**:
  * Protocol: IKEv2 / IPsec (ESP)
  * Traffic Selectors: `10.0.0.0/16 === 10.1.0.0/16`
  * Encryption / Integrity: AES-CBC-128 / HMAC-SHA2-256-128

## 3. Implementation Phases
### Phase 1: Base Container Infrastructure & Volume Mounting
* Custom `Dockerfile.router` based on Ubuntu 22.04 with natively compiled FRR and strongSwan.
* Configured Docker Compose network bridge (`192.168.56.0/24`) with explicit static IP assignments.
* Resolved container volume mount structures by mapping `ipsec.conf` and `ipsec.secrets` directly into `/etc/`.

### Phase 2: Secure IPsec VPN Tunnel
* Deployed strongSwan IKEv2 daemon with Pre-Shared Key (PSK) authentication.
* Established secure Child Security Associations (`net-to-net`) utilizing AES-CBC-128 encryption and HMAC-SHA2-256 integrity checks.

### Phase 3: BGP Dynamic Routing & Validation
* Configured FRR BGP peering between AS 65001 (`cloud-router`) and AS 65002 (`telco-router`).
* Advertised and verified loopback subnets (`10.0.0.1/32` and `10.1.0.1/32`) across the encrypted tunnel.

### Phase 4: Monitoring & Observability
* Integrated **Prometheus** into the Docker Compose network topology to scrape telemetry and monitor service health.
* Configured explicit self-scrape jobs in `prometheus.yml` communicating over the isolated bridge network (`net-mgmt`, `192.168.56.0/24`).

## 4. Validation & Testing Results
* **IPsec Security Associations**: Successfully established and installed (`ESTABLISHED` / `INSTALLED`).
* **BGP Peering**: Established (`State/PfxRcd: 1`), exchanging loopback routes stably without flapping.
* **End-to-End Connectivity**: Verified via ICMP ping across encrypted loopback addresses (`10.0.0.1` ↔ `10.1.0.1`) with **0% packet loss** and sub-millisecond latency.
* **Observability**: Prometheus container actively tracking scraper targets and health states.
* **CI/CD Automation**: Integrated GitHub Actions workflow validating the complete pipeline across all phases.
