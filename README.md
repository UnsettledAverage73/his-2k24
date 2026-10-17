# CIS Benchmark Linux Security Engine (`his-2k24`)

[![Linux](https://img.shields.io/badge/Linux-Enterprise%20Security-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![Red Hat Enterprise Linux](https://img.shields.io/badge/RHEL-8%20%7C%209-CC0000?style=for-the-badge&logo=redhat&logoColor=white)](https://www.redhat.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu%20Server-20.04%20%7C%2022.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/server)
[![Python](https://img.shields.io/badge/Python-3.8+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![CI](https://github.com/UnsettledAverage73/his-2k24/actions/workflows/ci.yml/badge.svg)](https://github.com/UnsettledAverage73/his-2k24/actions/workflows/ci.yml)
[![Smart India Hackathon](https://img.shields.io/badge/SIH%202024-National%20Finalist%20(NTRO)-FF9933?style=for-the-badge)](https://sih.gov.in/)

An automated **Center for Internet Security (CIS) Benchmark** compliance evaluation and remediation engine built for enterprise Linux infrastructure (**RHEL 8/9**, **Ubuntu Server**, and Windows). Recognized as a **National Finalist at Smart India Hackathon (SIH) 2024** for the **NTRO (National Technical Research Organisation)** problem statement.

---

## 🏛️ Architecture & Capabilities

The engine is engineered in a multi-tier architecture to support both headless production server pipelines and desktop administrative auditing:

```text
his-2k24/
├── cis_audit.py            # Headless CLI Audit & Remediation Runner (RHEL 8/9, Ubuntu)
├── api.py                  # High-throughput FastAPI backend with Paramiko SSH dispatch
├── requirements.txt        # Backend dependencies (fastapi, psutil, paramiko)
├── gui/                    # Desktop administrative console built in PySide6
│   ├── main.py             # GUI application entry point
│   ├── components/         # Modular Qt UI components
│   └── requirements.txt    # PySide6 desktop dependencies
├── rhel/                   # RHEL 8 and RHEL 9 CIS Benchmark scripts
│   ├── v8/                 # RHEL 8 CIS Benchmark v3.0 checks & remediations
│   └── v9/                 # RHEL 9 CIS Benchmark v1.0 checks & remediations
│       ├── 1_initial_setup/
│       ├── 2._Services/
│       ├── 3._network/
│       ├── 4.firewall_hostbased/
│       ├── 5.access_control/
│       ├── 6.logging_auding/
│       └── 7.system_maintenance/
├── ubuntu/                 # Ubuntu Desktop compliance suites
├── ubuntu_server/          # Ubuntu Server enterprise compliance suites
└── win11/                  # Windows 11 standalone & enterprise audits
```

---

## 🛡️ Covered CIS Benchmark Domains

| Domain | Scope & Controls Tested |
| :--- | :--- |
| **1. Initial Setup & Partitioning** | Filesystem isolation (`/tmp`, `/var`, `/home`), mount options (`nodev`, `nosuid`, `noexec`), kernel filesystem modules disablement (cramfs, squashfs, udf), cryptographic policies (`update-crypto-policies --set DEFAULT`). |
| **2. Services & Daemons** | Verification and removal of legacy insecure services (xinetd, telnet, rsh, NIS, talk), disabling unneeded network daemons. |
| **3. Network Configuration** | Kernel parameter hardening via `/etc/sysctl.d/`: IP forwarding disabled, reverse path filtering (`rp_filter`), dropping ICMP redirects, Martian packet logging. |
| **4. Host-Based Firewalls** | Validation of `firewalld` and `nftables` default-deny policies, active zone assignments, unapproved port closure. |
| **5. Access Control & PAM** | SSH daemon hardening (`sshd_config` protocol, root login prevention, cipher suites, MaxAuthTries), PAM authentication (`pam_faillock.so`, `pam_pwquality.so` password complexity, `pam_pwhistory.so`), `/etc/shadow` and `/etc/passwd` permissions. |
| **6. Logging & Auditing** | `auditd` daemon active verification, system call auditing (`execve`, file deletion, permission changes), `/var/log/audit/` partition retention policies. |
| **7. System Maintenance** | Sticky bit verification on public world-writable directories, SUID/SGID binary auditing, detection of orphaned files without user or group ownership. |

---

## ⚡ Quick Start: Headless CLI Audit Runner

No graphical display required. Run directly on any server or inside CI/CD test environments:

### 1. Run Complete RHEL 9 Audit
```bash
python3 cis_audit.py --os rhel9
```

### 2. Run Audit on Specific Security Category
```bash
# Audit Access Control, PAM & SSH
python3 cis_audit.py --os rhel9 --category access_control

# Audit Host Firewalls
python3 cis_audit.py --os rhel9 --category firewall
```

### 3. Export Machine-Readable JSON Compliance Report
```bash
python3 cis_audit.py --os rhel9 --category access_control --output rhel9_audit_report.json
```

Sample CLI output:
```text
========================================================
 CIS Benchmark Linux Security Engine - AUDIT MODE
 Target: RHEL9 | Scripts Found: 69
 Timestamp: 2026-10-18 03:56:12
========================================================

[01/69] Evaluating: 5.access_control/1.config_sshserver/1.config_sshd/check.sh ... [PASS]
[02/69] Evaluating: 5.access_control/1.config_sshserver/20.PermitRootlogin_sshd/check.sh ... [PASS]
...
--------------------------------------------------------
 SUMMARY: Total: 69 | Passed: 61 | Failed: 8
 Compliance Score: 88.4%
--------------------------------------------------------
```

### 4. Run Automated Remediation Mode
```bash
sudo python3 cis_audit.py --os rhel9 --category access_control --mode remediate
```

---

## 🌐 FastAPI Remote SSH Audit Server

Start the REST API for remote agentless auditing across networked Linux nodes:

```bash
uvicorn api:app --host 0.0.0.0 --port 8000
```

- **Interactive API Docs:** Navigate to `http://localhost:8000/docs`
- **Endpoints:**
  - `GET /system-status`: Real-time host telemetry (CPU, RAM, Disk, OS).
  - `POST /run-audit/{os}`: Dispatches target bash test scripts locally or over SSH via Paramiko.
  - `GET /audit-history`: Retrieve historical audit compliance logs.

---

## 🖥️ PySide6 Graphical Desktop Console

Launch the desktop interface for interactive visual audits:

```bash
cd gui
python3 main.py
```

---

## 👤 Author & Credentials
**Atharva Bodade**  
- **Red Hat Certified:** RH124 & RH134 (RHEL v9.3)
- **National Finalist:** Smart India Hackathon (SIH 2024 - NTRO Problem Statement)
- **GitHub:** [@unsettledaverage73](https://github.com/unsettledaverage73)
- **LinkedIn:** [linkedin.com/in/unsettledaverage73](https://www.linkedin.com/in/unsettledaverage73/)
- **Email:** atharvabodade@gmail.com
