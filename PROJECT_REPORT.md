# Comprehensive Project Report: Hybrid Cloud Network Automation & BGP Fabric

## Executive Summary
This document outlines the complete lifecycle, architecture, encountered errors, troubleshooting deadlocks, and final outcomes for **Phase 1 (Infrastructure & IaC)** and **Phase 2 (Containerized BGP Routing)** of the network automation project.

---

## Phase 1: Infrastructure Provisioning & IaC Fabric

### Architecture & Overview
- Provisioned core virtual networking infrastructure using Terraform.
- Implemented modular network peering (`modules/network_peer`) to manage multi-region cloud interconnects.
- Established automated CI pipelines for configuration validation.

### Challenges & Troubleshooting
- **State Lock & Credential Misalignment**: Resolved initial cloud provider authentication timeouts by verifying local credential profiles and state locks.
- **Dependency Ordering**: Addressed missing resource dependency links in Terraform modules by explicitly defining `depends_on` attributes between peering links and subnets.

### Outcome
A fully reproducible Infrastructure-as-Code (IaC) baseline deployed and synchronized with GitHub.

---

## Phase 2: Containerized BGP Routing & Dynamic Exchange

### Architecture & Overview
- Deployed a multi-container routing lab using Docker Compose and Free Range Routing (FRR).
- Configured two distinct Autonomous Systems:
  - **`cloud-router`**: AS `65001`, IP `192.168.56.10`, Loopback `10.0.0.1/32`.
  - **`telco-router`**: AS `65002`, IP `192.168.56.20`, Loopback `10.1.0.1/32`.

### Errors Faced & Troubleshooting Log

1. **BGP State Stalled in Active/Connect**
   - *Error*: Initial container bring-up failed to establish BGP peering sessions.
   - *Cause*: Bridge interface subnet mismatch and missing remote-as definitions in FRR daemon configs.
   - *Fix*: Standardized the peering subnet to `192.168.56.0/24` across `docker-compose.yml` and explicitly declared `neighbor remote-as` mappings.

2. **Prefix Exchange Blocked by Default Policy (`(Policy)`)**
   - *Error*: `show ip bgp summary` showed established uptime, but `State/PfxRcd` displayed `(Policy)` and zero prefixes were received.
   - *Cause*: FRR enforces strict default drop policies on inbound and outbound BGP updates unless explicitly permitted.
   - *Fix*: Created explicit `route-map ALLOW-ALL permit 10` rules and applied them inbound/outbound alongside `soft-reconfiguration inbound`.

3. **Missing Route Advertisements due to FRR `network` Statement Rules**
   - *Error*: Even with policies allowed, remote routes were not propagating because `network 10.0.0.0/16` lacked a matching covering route in the system routing table.
   - *Cause*: FRR requires the exact advertised prefix (or a covering route) to exist locally before injecting it into BGP.
   - *Fix*: Assigned exact `/32` loopback IP addresses (`10.0.0.1/32` and `10.1.0.1/32`) to the container `lo` interfaces and updated BGP network statements accordingly.

### Final Outcome
Full bi-directional BGP route exchange established and verified. Both `cloud-router` and `telco-router` successfully learn each other's loopback prefixes via dynamic BGP updates.
