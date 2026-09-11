# Troubleshooting Guide: Network Automation Lab

This guide documents common issues, diagnostic steps, and resolutions encountered across Phases 1 through 4 of the network automation laboratory.

---

## Phase 1: Base Container Infrastructure & Disk Space
* **Symptom**: `docker compose up` fails or image pulls fail with disk capacity errors (`No space left on device`).
* **Root Cause**: The host root filesystem is near capacity, restricting Docker image layer extractions.
* **Resolution**:
  1. Check available disk space: `df -h`
  2. Prune unused Docker cache and stopped containers:
     ```bash
     docker system prune -a --volumes -f
     ```
  3. Omit heavy optional services (e.g., Grafana) if host resources are restricted.

---

## Phase 2: IPsec VPN Tunnel (`strongSwan`)
* **Symptom**: Child Security Associations fail to establish (`ESTABLISHED` state missing).
* **Root Cause**: Mismatched Pre-Shared Keys (PSK), incorrect traffic selectors, or firewall/routing blocks.
* **Resolution**:
  1. Inspect strongSwan logs and tunnel status inside the router container:
     ```bash
     docker exec -it cloud-router ipsec statusall
     ```
  2. Verify that `ipsec.secrets` and `ipsec.conf` match identically on both `cloud-router` and `telco-router`.
  3. Ensure container capabilities (`NET_ADMIN`, `SYS_ADMIN`) are properly declared in `docker-compose.yml`.

---

## Phase 3: BGP Dynamic Routing (`FRR`)
* **Symptom**: BGP peering stuck in `Idle` or `Active` state.
* **Root Cause**: Incorrect Autonomous System (AS) numbers, peer IP address mismatches, or BGP password authentication errors.
* **Resolution**:
  1. Check BGP summary table inside FRR vtysh:
     ```bash
     docker exec -it cloud-router vtysh -c "show ip bgp summary"
     ```
  2. Verify network reachability between router management and peering interfaces via `ping`.
  3. Restart FRR service inside the container if configuration changes fail to take effect:
     ```bash
     docker exec -it cloud-router systemctl restart frr
     ```

---

## Phase 4: Monitoring & Observability (`Prometheus`)
* **Symptom**: Prometheus targets show as `down` or `unknown`.
* **Root Cause**: Misconfigured `prometheus.yml` scrape endpoints or unreachable bridge network ports.
* **Resolution**:
  1. Access the Prometheus web interface at `http://localhost:9090/targets` to inspect target health.
  2. Verify connectivity from the Prometheus container to target endpoints:
     ```bash
     docker exec -it prometheus nc -zv <target-ip> <port>
     ```
  3. Ensure scrape jobs are properly defined within the `net-mgmt` isolated bridge network (`192.168.56.0/24`).
