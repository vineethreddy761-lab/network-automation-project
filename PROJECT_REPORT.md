# Network Automation Project: Multi-Cloud BGP & IPsec VPN Architecture

## 1. Executive Summary
This project successfully establishes a secure, automated multi-router transit environment using **Free Range Routing (FRR)** for BGP dynamic routing and **strongSwan (IKEv2)** for IPsec encryption over a simulated multi-site topology.

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

## 3. Validation & Testing Results
* **IPsec Security Associations**: Successfully established and installed (`ESTABLISHED` / `INSTALLED`).
* **BGP Peering**: Established (`State/PfxRcd: 1`), exchanging loopback routes stably over 7+ minutes without flapping.
* **End-to-End Connectivity**: Verified via ICMP ping across encrypted loopback addresses (`10.0.0.1` $\leftrightarrow$ `10.1.0.1`) with **0% packet loss** and sub-millisecond latency.
