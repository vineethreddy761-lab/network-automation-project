# Network Automation Project

A comprehensive network automation and routing lab environment featuring Docker-based FRR (Free Range Routing) routers, multi-cloud BGP peering, and automated infrastructure provisioning.

## Project Structure
- **configs/**: FRR routing and BGP configuration files.
- **scripts/**: Setup and automation scripts (including VPN configuration).
- **modules/network_peer/**: Terraform modules for network peering.
- **docker-compose.yml**: Multi-container topology for `cloud-router` and `telco-router`.

## Features
- BGP Peering (AS 65001 & AS 65002) with dynamic route exchange.
- Containerized network topology using Docker and FRR.
- Automated provisioning via Terraform and CI/CD pipelines.
