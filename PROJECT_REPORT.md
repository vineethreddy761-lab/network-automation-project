# Comprehensive Project Report: Hybrid Cloud Network Automation & IaC Fabric (Phase 1)

## 1. Project Overview & Objectives
* **Goal:** Design and implement a production-grade "Infrastructure/Network Automation" project aligning with professional job requirements.
* **Core Technologies:** Terraform (IaC), Docker (lightweight containerization), Python (custom dynamic IPAM data source), FRRouting (BGP routing), StrongSwan (IPsec VPN), and GitLab CI/CD.
* **Architecture:** Simulated hybrid-cloud network fabric featuring local interconnected routing nodes (`cloud-router` and `telco-router`).

---

## 2. Step-by-Step Implementation & What We Did
1. **Host Storage Assessment:** Evaluated host disk headroom (`df -h`) and identified a critical constraint on the root partition (`/dev/mapper/ubuntu--vg-ubuntu--lv` at 90% capacity with only 1.1G available).
2. **Infrastructure Pivot:** Switched from resource-heavy Vagrant/VirtualBox virtual machines to lightweight Docker containers sharing the host kernel to bypass storage limitations while retaining full network administration capabilities (`CAP_NET_ADMIN`).
3. **Container Orchestration:** Created a `docker-compose.yml` file defining `cloud-router` and `telco-router` nodes running Ubuntu 22.04.
4. **Terraform Modularization:** Established root configuration files (`main.tf`, `outputs.tf`) and built a reusable local Terraform module (`modules/network_peer/`) to manage network peer parameters.
5. **Dynamic Data Source Integration:** Developed a custom Python script (`scripts/custom_ipam.py`) acting as a Terraform external data provider to dynamically generate ASN mappings and tunnel subnets.
6. **Routing & CI/CD Pipelines:** Drafted FRR BGP routing configuration templates (`configs/router_bgp.conf`) and a complete GitLab CI/CD pipeline (`.gitlab-ci.yml`) covering validation, testing, and planning stages.
7. **Operational Documentation:** Created an operational playbook (`TROUBLESHOOTING.md`) for diagnosing BGP and IPsec VPN session failures.

---

## 3. Errors Faced & How We Overcame Them

### Error 1: Vagrant Resource & Disk Space Limitation
* **Symptom:** Inability to provision Vagrant virtual machine images due to low disk space on the root partition (`1.1G` available).
* **Resolution:** Cleaned up Vagrant artifacts and pivoted entirely to Docker containers, which require negligible disk space and support low-level networking capabilities (`--cap-add=NET_ADMIN`).

### Error 2: Missing FRR Binary Execution Path
* **Symptom:** `OCI runtime exec failed: exec: "frr": executable file not found in $PATH` when attempting to test FRR directly.
* **Resolution:** Corrected the command execution by calling the integrated routing shell (`vtysh`) instead of looking for a monolithic `frr` executable binary.

### Error 3: Terraform Module Initialization Error
* **Symptom:** `Error: Module not installed` when applying configuration after introducing `modules/network_peer`.
* **Resolution:** Executed `terraform init` to download, scan, and link local custom modules into the working directory.

### Error 4: Unexpected External Program Results (Empty JSON Output)
* **Symptom:** `Error: Unexpected External Program Results - Result Error: unexpected end of JSON input` when Terraform attempted to execute `custom_ipam.py`.
* **Resolution:** Updated `scripts/custom_ipam.py` to robustly read and handle incoming payloads via `sys.stdin` with safe fallback blocks, ensuring valid single-line JSON output to `stdout`.

### Error 5: Wrong Working Directory for Terraform Execution
* **Symptom:** `Error: No configuration files` when running `terraform apply` while located inside the `scripts/` subdirectory.
* **Resolution:** Navigated back to the project root directory (`cd ..`) where `main.tf` resides.

### Error 6: Git Author Identity Missing
* **Symptom:** `Author identity unknown ... fatal: unable to auto-detect email address` during repository initialization and commit.
* **Resolution:** Configured local repository git identity via `git config user.name` and `git config user.email`.

---

## 4. Final Accomplishments & Deliverables
* Fully functional, modular Terraform IaC setup with dynamic Python-backed external data integration.
* Active, lightweight Docker-based hybrid cloud network routers.
* Version-controlled repository containing pipeline automation (`.gitlab-ci.yml`), routing templates, and a comprehensive operational troubleshooting playbook (`TROUBLESHOOTING.md`).
* Phase 1 successfully completed, committed, and fully verified.
