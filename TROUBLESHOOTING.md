# Infrastructure & Network Automation Troubleshooting Playbook

This playbook outlines diagnostic procedures and resolution steps for BGP routing and IPSec VPN tunnels built in this project[cite: 1].

## 1. BGP Troubleshooting
* **Symptom:** BGP neighbor state stuck in `Active` or `Connect`.
* **Diagnostic Steps:**
  1. Verify TCP port 179 connectivity between peers: `nc -zv <peer_ip> 179`
  2. Check FRR neighbor status using the integrated shell: `vtysh -c "show ip bgp summary"`
  3. Verify Autonomous System Number (ASN) configuration matches on both peers.
* **Resolution:** Ensure local firewalls or security groups permit TCP 179 and verify that router IDs do not conflict.

## 2. IPSec VPN Tunnel Troubleshooting
* **Symptom:** Phase 1 or Phase 2 IKE negotiation failure.
* **Diagnostic Steps:**
  1. Check StrongSwan daemon status: `sudo swanctl --list-sas` or `sudo ipsec status`
  2. Inspect real-time logs for proposal mismatches (encryption, hashing, or DH groups): `sudo journalctl -u strongswan -f`
* **Resolution:** Align Pre-Shared Keys (PSK), encryption algorithms, and lifetime parameters on both ends of the tunnel.

## 3. GitLab CI/CD Pipeline Failures
* **Symptom:** Terraform linting or validation failure in the pipeline.
* **Diagnostic Steps:**
  1. Run local validation matching the pipeline stages: `terraform validate` and `terraform fmt -check`
  2. Verify external script output format: `python3 scripts/custom_ipam.py`
* **Resolution:** Correct JSON schema output formatting or syntax errors prior to pushing.
