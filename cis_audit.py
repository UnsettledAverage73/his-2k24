#!/usr/bin/env python3
"""
CIS Benchmark Linux Security Engine - Headless CLI Audit & Remediation Runner
Supports: RHEL 8/9, Ubuntu Server 20.04/22.04
Engineered for Smart India Hackathon (SIH 2024 - NTRO Problem Statement)
Author: Atharva Bodade (UnsettledAverage73)
"""

import os
import sys
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

CATEGORIES = [
    "1_initial_setup",
    "2._Services",
    "3._network",
    "4.firewall_hostbased",
    "5.access_control",
    "6.logging_auding",
    "7.system_maintenance",
]


def detect_platform():
    """Detect local operating system distribution."""
    if not os.path.exists("/etc/os-release"):
        return "unknown"
    with open("/etc/os-release", "r") as f:
        content = f.read().lower()
        if "rhel" in content or "red hat" in content:
            if "version_id=\"9" in content or "version_id=\"9" in content:
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


def run_audit(target_os: str, category_filter: str = None, mode: str = "audit"):
    """Run compliance audit or remediation suite."""
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
    print(f" Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"========================================================\n")

    results = []
    passed = 0
    failed = 0

    for i, script in enumerate(all_scripts, 1):
        rel_path = script.relative_to(target_dir)
        print(f"[{i:02d}/{len(all_scripts):02d}] Evaluating: {rel_path} ... ", end="", flush=True)
        res = execute_script(script)
        results.append(res)

        if res["status"] == "PASS":
            passed += 1
            print("\033[92m[PASS]\033[0m")
        else:
            failed += 1
            print("\033[91m[FAIL]\033[0m")

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
        "--output",
        type=str,
        default=None,
        help="Path to export structured JSON compliance report",
    )

    args = parser.parse_args()

    target_os = args.os
    if target_os == "auto":
        detected = detect_platform()
        if detected != "unknown":
            print(f"[+] Auto-detected platform: {detected}")
            target_os = detected
        else:
            print("[!] Could not auto-detect platform. Defaulting to rhel9.")
            target_os = "rhel9"

    report = run_audit(target_os=target_os, category_filter=args.category, mode=args.mode)

    if args.output:
        out_path = Path(args.output)
        with open(out_path, "w") as f:
            json.dump(report, f, indent=2)
        print(f"[+] Full JSON audit report exported to: {out_path.resolve()}")


if __name__ == "__main__":
    main()
