# inference.py
"""
This module contains backend logic for system operations, script execution, and status reporting.
"""

import os
import subprocess
import psutil
import platform
import datetime
from pathlib import Path
import paramiko

# --- System Monitoring ---
def get_system_status():
    return {
        "cpu": psutil.cpu_percent(),
        "memory": psutil.virtual_memory().percent,
        "disk": psutil.disk_usage('/').percent,
        "system": f"{platform.system()} {platform.release()}"
    }

def get_processes():
    processes = []
    for proc in psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_percent', 'status']):
        try:
            pinfo = proc.info
            processes.append(pinfo)
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
    processes.sort(key=lambda x: x['cpu_percent'], reverse=True)
    return processes

# --- Script Execution ---
def execute_script(script_path):
    try:
        result = subprocess.run(["bash", script_path], capture_output=True, text=True)
        return {
            "script": script_path,
            "output": result.stdout,
            "error": result.stderr,
            "success": result.returncode == 0,
            "returncode": result.returncode
        }
    except Exception as e:
        return {
            "script": script_path,
            "output": "",
            "error": str(e),
            "success": False,
            "returncode": None
        }

def find_all_scripts(base_dir="rhel/v8"):
    """Recursively find all .sh scripts under the given directory."""
    script_paths = []
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.sh'):
                script_paths.append(os.path.join(root, file))
    return script_paths

def run_complete_check():
    """Execute all .sh scripts under rhel/v8 and return their results."""
    scripts = find_all_scripts()
    return [execute_script(script) for script in scripts]

# --- Backup Management ---
def create_backup():
    backup_dir = Path("backups")
    backup_dir.mkdir(exist_ok=True)
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = backup_dir / f"backup_{timestamp}"
    backup_path.mkdir()
    return {"message": f"Backup created at {backup_path}"}

def list_backups():
    backup_dir = Path("backups")
    if not backup_dir.exists():
        return []
    backups = list(backup_dir.glob("backup_*"))
    return [
        {
            "path": str(backup),
            "date": datetime.datetime.fromtimestamp(backup.stat().st_mtime).strftime("%Y-%m-%d %H:%M:%S"),
            "size_kb": f"{backup.stat().st_size/1024:.1f} KB"
        }
        for backup in backups
    ]

def delete_backup(backup_name):
    backup_path = Path("backups") / backup_name
    if backup_path.exists() and backup_path.is_dir():
        for item in backup_path.iterdir():
            if item.is_file():
                item.unlink()
            else:
                delete_backup(item)
        backup_path.rmdir()
        return {"message": f"Deleted {backup_name}"}
    return {"error": "Backup not found"}

# --- Remote Execution (Stub) ---
def run_remote_command(host, port, username, password, command):
    # You can implement SSH logic here using paramiko
    return {"output": "Remote execution not implemented yet.", "success": False}

# --- Audit History (Stub) ---
def get_audit_history():
    # You can implement DB or file-based history here
    return []

def run_script_local(script_path):
    result = subprocess.run(["bash", script_path], capture_output=True, text=True)
    return result.stdout + result.stderr

def run_script_ssh(host, username, password, script_path):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(host, username=username, password=password)
    stdin, stdout, stderr = ssh.exec_command(f"bash {script_path}")
    output = stdout.read().decode() + stderr.read().decode()
    ssh.close()
    return output

def process_log(log):
    lines = log.splitlines()
    summary = [line for line in lines if any(word in line for word in ["PASS", "FAIL", "ERROR"])]
    return "\n".join(summary)

def execute_on_devices(audits, devices, device_info, dry_run=False):
    results = []
    for device in devices:
        if device == "local":
            for script in audits:
                if dry_run:
                    log = f"Simulated execution of {script} on local"
                    summary = "Simulated"
                else:
                    log = run_script_local(script)
                    summary = process_log(log)
                results.append({
                    "device": "local",
                    "script": script,
                    "log": log,
                    "summary": summary
                })
        else:
            info = device_info.get(device)
            if not info or info.get("status") != "connected":
                results.append({
                    "device": device,
                    "script": None,
                    "log": "",
                    "summary": "Device not connected"
                })
                continue
            for script in audits:
                if dry_run:
                    log = f"Simulated execution of {script} on {device}"
                    summary = "Simulated"
                else:
                    log = run_script_ssh(info["host"], info["username"], info["password"], script)
                    summary = process_log(log)
                results.append({
                    "device": device,
                    "script": script,
                    "log": log,
                    "summary": summary
                })
    return results 