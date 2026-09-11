# Infrastructure & Network Automation Troubleshooting Playbook

This playbook outlines diagnostic procedures and resolution steps across all three phases of the network automation lab.

## Phase 1: Container Infrastructure & Volume Mounting
* **Symptom:** StrongSwan fails to load configuration or complains that `ipsec.conf` is missing.
* **Diagnostic Steps:**
  1. Check file placement inside the container: `docker exec -it cloud-router ls -la /etc/`
  2. Verify volume mounts in `docker-compose.yml` (`./configs/vpn/ipsec.conf:/etc/ipsec.conf`).
* **Resolution:** Mount configuration files directly into `/etc/ipsec.conf` instead of mounting the directory onto `/etc/ipsec.d`.

## Phase 2: IPsec VPN Tunnel (strongSwan)
* **Symptom:** Tunnel stuck in `CONNECTING` state with retransmissions (`peer not responding`).
* **Diagnostic Steps:**
  1. Check strongSwan status on both routers: `docker exec -it cloud-router ipsec statusall`
  2. Verify pre-shared keys in `/etc/ipsec.secrets` match on both peers.
* **Resolution:** Restart the strongSwan daemon (`ipsec restart`) and manually trigger the connection (`ipsec up net-to-net`).

## Phase 3: BGP Routing & Prefix Exchange
* **Symptom:** BGP neighbor stuck in `Idle` or `Connect`, or loopback routes not propagating.
* **Diagnostic Steps:**
  1. Check BGP summary via FRR shell: `docker exec -it cloud-router vtysh -c "show ip bgp summary"`
  2. Verify loopback address assignments: `docker exec -it cloud-router ip addr show dev lo`
* **Resolution:** Ensure loopback addresses (`10.0.0.1/32` and `10.1.0.1/32`) are properly assigned inside each router container and BGP networks are correctly advertised.
