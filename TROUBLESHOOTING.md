# Infrastructure & Network Automation Troubleshooting Playbook

This playbook outlines diagnostic procedures and resolution steps encountered across Phases 1 through 4 of the network automation laboratory, including container infrastructure, BGP routing, IPsec VPN tunnels, and CI/CD pipelines.

---

## 1. Phase 1: Base Container Infrastructure & Disk Space
* **Symptom:** `docker compose up` fails or image pulls fail with disk capacity errors (`No space left on device`).
* **Diagnostic Steps:**
  1. Check available disk space: `df -h`
  2. Inspect Docker resource utilization.
* **Resolution:** Prune unused Docker cache and stopped containers (`docker system prune -a --volumes -f`), or omit heavy optional services (e.g., Grafana) if host resources are restricted.

## 2. Phase 2: IPsec VPN Tunnel Troubleshooting (`strongSwan`)
* **Symptom:** Phase 1/2 IKE negotiation failure or Child Security Associations fail to establish (`ESTABLISHED` state missing).
* **Diagnostic Steps:**
  1. Check strongSwan daemon status and security associations inside the router container: `docker exec -it cloud-router ipsec statusall` (or `sudo swanctl --list-sas`)
  2. Inspect real-time logs for proposal mismatches (encryption, hashing, or DH groups): `sudo journalctl -u strongswan -f`
* **Resolution:** Align Pre-Shared Keys (`ipsec.secrets`), encryption algorithms (AES-CBC-128), and integrity hashes (HMAC-SHA2-256) identically on both ends of the tunnel (`cloud-router` and `telco-router`). Ensure container capabilities (`NET_ADMIN`, `SYS_ADMIN`) are enabled.

## 3. Phase 3: BGP Dynamic Routing Troubleshooting (`FRR`)
* **Symptom:** BGP neighbor state stuck in `Idle`, `Active`, or `Connect`.
* **Diagnostic Steps:**
  1. Verify TCP port 179 connectivity between peers: `nc -zv <peer_ip> 179`
  2. Check FRR neighbor status using the integrated shell: `docker exec -it cloud-router vtysh -c "show ip bgp summary"`
  3. Verify Autonomous System Number (ASN) configuration matches on both peers and check network reachability via `ping`.
* **Resolution:** Ensure local firewalls or security groups permit TCP 179, verify router IDs do not conflict, and restart FRR if needed (`docker exec -it cloud-router systemctl restart frr`).

## 4. Phase 4: Monitoring & Observability (`Prometheus`)
* **Symptom:** Prometheus targets show as `down` or `unknown`.
* **Diagnostic Steps:**
  1. Access the Prometheus web interface at `http://localhost:9090/targets` to inspect target health.
  2. Verify connectivity from the Prometheus container to target endpoints: `docker exec -it prometheus nc -zv <target-ip> <port>`
* **Resolution:** Ensure scrape jobs are properly defined within the `net-mgmt` isolated bridge network (`192.168.56.0/24`).

## 5. Phase 5: GitLab CI/CD Pipeline Failures
* **Symptom:** Terraform linting or validation failure in the pipeline.
* **Diagnostic Steps:**
  1. Run local validation matching the pipeline stages: `terraform validate` and `terraform fmt -check`
  2. Verify external script output format: `python3 scripts/custom_ipam.py`
* **Resolution:** Correct JSON schema output formatting or syntax errors prior to pushing.
