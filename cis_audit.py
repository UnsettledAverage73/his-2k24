#!/usr/bin/env python3
"""
CIS Benchmark Linux Security Engine - Production-Ready CLI Audit & Remediation Suite
Features: Headless Auditing, Safe Remediation, Atomic Config Snapshots, Automated Rollback
Supports: RHEL 8/9, Ubuntu Server 20.04/22.04
Engineered for Smart India Hackathon (SIH 2024 - NTRO Problem Statement)
Author: Atharva Bodade (UnsettledAverage73)
"""

import os
import sys
import shutil
import hashlib
import argparse
import subprocess
import json
import platform
from datetime import datetime
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent

SUPPORTED_TARGETS = {
    "rhel9": BASE_DIR / "rhel" / "v9",
    "rhel8": BASE_DIR / "rhel" / "v8",
    "ubuntu": BASE_DIR / "ubuntu",
    "ubuntu_server": BASE_DIR / "ubuntu_server",
}

CRITICAL_CONFIG_PATHS = [
    "/etc/ssh",
    "/etc/pam.d",
    "/etc/sysctl.d",
    "/etc/security",
    "/etc/fstab",
    "/etc/issue.net",
]


class ProductionSafetyManager:
    """Manages pre-flight atomic snapshots, system health checks, and zero-breakage rollbacks."""

    def __init__(self, snapshot_root: Path = None, backup_root: Path = None):
        root = snapshot_root or backup_root
        if root:
            self.snapshot_root = Path(root)
        else:
            self.snapshot_root = Path("/var/backups/cis_snapshots") if os.access("/var/backups", os.W_OK) else Path("/tmp/cis_snapshots")
        self.snapshot_root.mkdir(parents=True, exist_ok=True)
        self.backup_root = self.snapshot_root
        self.snapshot_dir = None
        self.manifest = {}

    def _hash_file(self, filepath: Path) -> str:
        """Compute SHA-256 hash of a file."""
        hasher = hashlib.sha256()
        try:
            with open(filepath, "rb") as f:
                while chunk := f.read(8192):
                    hasher.update(chunk)
            return hasher.hexdigest()
        except Exception:
            return ""

    def create_snapshot(self, target_paths: list = None) -> Path:
        """Create timestamped snapshot of critical enterprise configuration files."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        self.snapshot_dir = self.snapshot_root / f"snapshot_{timestamp}"
        self.snapshot_dir.mkdir(parents=True, exist_ok=True)

        paths_to_backup = target_paths if target_paths is not None else CRITICAL_CONFIG_PATHS
        print(f"\n[+] Production Safety: Creating configuration snapshot in {self.snapshot_dir} ...")

        for target_path_str in paths_to_backup:
            target_path = Path(target_path_str)
            if not target_path.exists():
                continue

            rel_dest = self.snapshot_dir / target_path.relative_to("/")
            try:
                if target_path.is_dir():
                    shutil.copytree(target_path, rel_dest, dirs_exist_ok=True)
                    for f in target_path.rglob("*"):
                        if f.is_file():
                            self.manifest[str(f)] = self._hash_file(f)
                else:
                    rel_dest.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(target_path, rel_dest)
                    self.manifest[str(target_path)] = self._hash_file(target_path)
            except Exception as e:
                print(f"[!] Warning copying {target_path}: {e}")

        # Save manifest
        with open(self.snapshot_dir / "manifest.json", "w") as f:
            json.dump({"timestamp": timestamp, "files": self.manifest}, f, indent=2)

        print(f"[✓] Snapshot created ({len(self.manifest)} critical files protected).")
        return self.snapshot_dir

    def verify_system_health(self) -> (bool, list):
        """Run post-remediation health checks to prevent service outages or lockout."""
        issues = []

        # 1. SSH Daemon Syntax Check
        if shutil.which("sshd"):
            proc = subprocess.run(["sshd", "-t"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            if proc.returncode != 0:
                issues.append(f"SSH syntax validation failed: {proc.stderr.strip()}")

        # 2. Critical File Existence & Non-empty
        for f in ["/etc/passwd", "/etc/shadow", "/etc/fstab"]:
            fp = Path(f)
            if not fp.exists() or fp.stat().st_size == 0:
                issues.append(f"Critical system file corrupted or missing: {f}")

        # 3. Network Gateway Ping (if route exists)
        try:
            route_proc = subprocess.run(["ip", "route", "show", "default"], stdout=subprocess.PIPE, text=True)
            if route_proc.stdout.strip():
                gw_ip = route_proc.stdout.split()[2]
                ping_proc = subprocess.run(["ping", "-c", "1", "-W", "2", gw_ip], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                if ping_proc.returncode != 0:
                    issues.append(f"Default gateway unreachable: {gw_ip}")
        except Exception:
            pass

        return (len(issues) == 0, issues)

    def rollback(self, target_snapshot: Path = None):
        """Roll back system configurations from snapshot."""
        restore_dir = target_snapshot or self.snapshot_dir
        if not restore_dir or not restore_dir.exists():
            print("[-] No snapshot found for rollback.")
            return False

        print(f"\n[!] ATTENTION: Rolling back configurations from {restore_dir} ...")

        manifest_file = restore_dir / "manifest.json"
        if manifest_file.exists():
            with open(manifest_file, "r") as f:
                data = json.load(f)
                files_to_restore = data.get("files", {}).keys()
        else:
            files_to_restore = [str(f.relative_to(restore_dir)) for f in restore_dir.rglob("*") if f.is_file()]

        restored_count = 0
        for orig_file in files_to_restore:
            backup_file = restore_dir / Path(orig_file).relative_to("/")
            if backup_file.exists():
                try:
                    Path(orig_file).parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(backup_file, orig_file)
                    restored_count += 1
                except Exception as e:
                    print(f"[-] Error restoring {orig_file}: {e}")

        # Reload system daemons
        if shutil.which("systemctl"):
            try:
                subprocess.run(["systemctl", "daemon-reload"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=3)
                subprocess.run(["systemctl", "restart", "sshd"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=3)
            except Exception:
                pass

        print(f"[✓] Rollback complete: {restored_count} files restored. Daemons refreshed.\n")
        return True


def detect_platform():
    """Detect local operating system distribution."""
    if not os.path.exists("/etc/os-release"):
        return "unknown"
    with open("/etc/os-release", "r") as f:
        content = f.read().lower()
        if "rhel" in content or "red hat" in content:
            if "version_id=\"9" in content or 'version_id="9' in content:
                return "rhel9"
            return "rhel8"
        elif "ubuntu" in content:
            return "ubuntu"
    return "unknown"


def discover_scripts(target_dir: Path, mode: str = "audit"):
    """
    Discover test or remediation scripts in target directory.
    mode: 'audit' (matches check.sh or *-test.sh)
          'remediate' (matches remedi*.sh or remediation scripts)
    """
    discovered = []
    if not target_dir.exists():
        return discovered

    for script_path in sorted(target_dir.rglob("*.sh")):
        name = script_path.name.lower()
        is_audit = name == "check.sh" or name.endswith("-test.sh")
        is_remediation = "remedi" in name or "remdi" in name

        if mode == "audit":
            if is_audit or (not is_remediation and "test" in name):
                discovered.append(script_path)
        elif mode == "remediate":
            if is_remediation or (not is_audit and "remedi" in name):
                discovered.append(script_path)

    return discovered


def execute_script(script_path: Path):
    """Execute bash script and capture exit code, stdout, and stderr."""
    try:
        proc = subprocess.run(
            ["/bin/bash", str(script_path)],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            timeout=30,
        )
        return {
            "name": script_path.name,
            "path": str(script_path.relative_to(BASE_DIR)),
            "exit_code": proc.returncode,
            "status": "PASS" if proc.returncode == 0 else "FAIL",
            "stdout": proc.stdout.strip(),
            "stderr": proc.stderr.strip(),
        }
    except subprocess.TimeoutExpired:
        return {
            "name": script_path.name,
            "path": str(script_path.relative_to(BASE_DIR)),
            "exit_code": -1,
            "status": "TIMEOUT",
            "stdout": "",
            "stderr": "Script execution timed out after 30 seconds",
        }
    except Exception as e:
        return {
            "name": script_path.name,
            "path": str(script_path.relative_to(BASE_DIR)),
            "exit_code": -1,
            "status": "ERROR",
            "stdout": "",
            "stderr": str(e),
        }


def run_audit(target_os: str, category_filter: str = None, mode: str = "audit", safe_mode: bool = False, dry_run: bool = False):
    """Run compliance audit or remediation suite with production safety guards."""
    if target_os not in SUPPORTED_TARGETS:
        print(f"[-] Unsupported target OS: {target_os}. Choose from: {list(SUPPORTED_TARGETS.keys())}")
        sys.exit(1)

    target_dir = SUPPORTED_TARGETS[target_os]
    if category_filter:
        matching_dirs = [d for d in target_dir.iterdir() if d.is_dir() and category_filter.lower() in d.name.lower()]
        if not matching_dirs:
            print(f"[-] Category '{category_filter}' not found in {target_dir}")
            sys.exit(1)
        search_dirs = matching_dirs
    else:
        search_dirs = [target_dir]

    all_scripts = []
    for d in search_dirs:
        all_scripts.extend(discover_scripts(d, mode=mode))

    print(f"\n========================================================")
    print(f" CIS Benchmark Linux Security Engine - {mode.upper()} MODE")
    print(f" Target: {target_os.upper()} | Scripts Found: {len(all_scripts)}")
    print(f" Production Safety: {'ENABLED (Auto-Rollback on)' if safe_mode else 'DISABLED'}")
    if dry_run:
        print(f" DRY-RUN: Simulation only. No changes will be applied.")
    print(f" Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"========================================================\n")

    safety_mgr = None
    if mode == "remediate" and safe_mode and not dry_run:
        safety_mgr = ProductionSafetyManager()
        safety_mgr.create_snapshot()

    results = []
    passed = 0
    failed = 0

    for i, script in enumerate(all_scripts, 1):
        rel_path = script.relative_to(target_dir)
        print(f"[{i:02d}/{len(all_scripts):02d}] Evaluating: {rel_path} ... ", end="", flush=True)

        if dry_run:
            print("\033[94m[SIMULATED]\033[0m")
            results.append({"name": script.name, "path": str(script.relative_to(BASE_DIR)), "status": "SIMULATED"})
            continue

        res = execute_script(script)
        results.append(res)

        if res["status"] == "PASS":
            passed += 1
            print("\033[92m[PASS]\033[0m")
        else:
            failed += 1
            print("\033[91m[FAIL]\033[0m")

    # Post-remediation health check
    if mode == "remediate" and safe_mode and not dry_run:
        print("\n[+] Running post-remediation enterprise health verification ...")
        healthy, issues = safety_mgr.verify_system_health()
        if not healthy:
            print("\033[91m[!] Critical System Health Checks Failed:\033[0m")
            for issue in issues:
                print(f"    - {issue}")
            print("\033[91m[!] Triggering Automatic Rollback to safeguard system...\033[0m")
            safety_mgr.rollback()
        else:
            print("\033[92m[✓] All post-remediation health checks passed successfully.\033[0m")

    print("\n--------------------------------------------------------")
    print(f" SUMMARY: Total: {len(results)} | \033[92mPassed: {passed}\033[0m | \033[91mFailed: {failed}\033[0m")
    compliance_score = (passed / len(results) * 100) if results else 0.0
    print(f" Compliance Score: {compliance_score:.1f}%")
    print("--------------------------------------------------------\n")

    return {
        "target_os": target_os,
        "mode": mode,
        "timestamp": datetime.now().isoformat(),
        "total": len(results),
        "passed": passed,
        "failed": failed,
        "compliance_score": round(compliance_score, 2),
        "results": results,
    }


def main():
    parser = argparse.ArgumentParser(
        description="CIS Benchmark Linux Security Engine (SIH 2024 - NTRO)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--os",
        choices=["rhel9", "rhel8", "ubuntu", "ubuntu_server", "auto"],
        default="auto",
        help="Target operating system distribution (default: auto-detect)",
    )
    parser.add_argument(
        "--category",
        type=str,
        default=None,
        help="Filter audit to specific category (e.g. firewall, access_control, filesystem)",
    )
    parser.add_argument(
        "--mode",
        choices=["audit", "remediate"],
        default="audit",
        help="Run in audit evaluation mode (test) or remediation mode (default: audit)",
    )
    parser.add_argument(
        "--safe",
        action="store_true",
        help="Enable production safety mode: pre-flight snapshot, health checks, auto-rollback on failure",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Simulate execution without modifying any system files or services",
    )
    parser.add_argument(
        "--rollback",
        type=str,
        default=None,
        metavar="SNAPSHOT_DIR",
        help="Roll back system configuration from a specific snapshot directory",
    )
    parser.add_argument(
        "--output",
        type=str,
        default=None,
        help="Path to export structured JSON compliance report",
    )

    args = parser.parse_args()

    # Manual Rollback handling
    if args.rollback:
        mgr = ProductionSafetyManager()
        success = mgr.rollback(Path(args.rollback))
        sys.exit(0 if success else 1)

    target_os = args.os
    if target_os == "auto":
        detected = detect_platform()
        if detected != "unknown":
            print(f"[+] Auto-detected platform: {detected}")
            target_os = detected
        else:
            print("[!] Could not auto-detect platform. Defaulting to rhel9.")
            target_os = "rhel9"

    report = run_audit(
        target_os=target_os,
        category_filter=args.category,
        mode=args.mode,
        safe_mode=args.safe,
        dry_run=args.dry_run,
    )

    if args.output:
        out_path = Path(args.output)
        with open(out_path, "w") as f:
            json.dump(report, f, indent=2)
        print(f"[+] Full JSON audit report exported to: {out_path.resolve()}")


if __name__ == "__main__":
    main()
