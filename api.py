from fastapi import FastAPI, HTTPException, Body
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime
from typing import List, Dict
import uuid
import os
import subprocess
import psutil
import platform
from pathlib import Path
import paramiko

app = FastAPI()

# Allow CORS for frontend (adjust origins as needed)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change to your frontend URL in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Example device info (in real app, fetch from DB or config)
DEVICE_INFO = {
    "local": {"status": "connected"},
    "dev1": {"host": "192.168.1.101", "username": "user", "password": "pass", "status": "connected"},
    "dev2": {"host": "192.168.1.102", "username": "user", "password": "pass", "status": "not_connected"},
}

# --- Audit History ---
AUDIT_HISTORY = []

def log_audit(action, status, details, system):
    AUDIT_HISTORY.insert(0, {
        "id": len(AUDIT_HISTORY) + 1,
        "action": action,
        "status": status,
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "details": details,
        "system": system
    })

def get_audit_history():
    return AUDIT_HISTORY

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
        # Log the execution
        log_audit(
            action=f"Script Executed: {os.path.basename(script_path)}",
            status="Completed" if result.returncode == 0 else "Failed",
            details=result.stdout if result.returncode == 0 else result.stderr,
            system="Server-DB-01"  # You can make this dynamic if needed
        )
        return {
            "script": script_path,
            "output": result.stdout,
            "error": result.stderr,
            "success": result.returncode == 0,
            "returncode": result.returncode
        }
    except Exception as e:
        log_audit(
            action=f"Script Executed: {os.path.basename(script_path)}",
            status="Failed",
            details=str(e),
            system="Server-DB-01"
        )
        return {
            "script": script_path,
            "output": "",
            "error": str(e),
            "success": False,
            "returncode": None
        }

def find_all_scripts(base_dir="rhel/v8"):
    script_paths = []
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.sh'):
                script_paths.append(os.path.join(root, file))
    return script_paths

def run_complete_check():
    scripts = find_all_scripts()
    return [execute_script(script) for script in scripts]

# --- Backup Management ---
def create_backup():
    backup_dir = Path("backups")
    backup_dir.mkdir(exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
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
            "date": datetime.fromtimestamp(backup.stat().st_mtime).strftime("%Y-%m-%d %H:%M:%S"),
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
    return {"output": "Remote execution not implemented yet.", "success": False}

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

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/system-status")
def system_status():
    return get_system_status()

@app.get("/system-processes")
def system_processes():
    return get_processes()

@app.post("/execute-script")
def run_script(script_name: str = Body(...)):
    try:
        result = execute_script(script_name)
        # Log the script execution
        log_audit(
            action=f"Script Executed: {script_name}",
            status="Completed" if result.get("success", True) else "Failed",
            details=result.get("message", str(result)),
            system="Server-DB-01"  # Or get the actual system name
        )
        return result
    except Exception as e:
        # Log the failure
        log_audit(
            action=f"Script Executed: {script_name}",
            status="Failed",
            details=str(e),
            system="Server-DB-01"
        )
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/complete-check")
def complete_check(permission: bool = Body(...)):
    if not permission:
        return {"message": "Permission required to run complete check.", "permission_required": True}
    try:
        results = run_complete_check()
        return {"results": results}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# --- Expert Mode Endpoints ---
@app.get("/expert/audits")
def list_audits():
    audits = []
    for root, dirs, files in os.walk("rhel/v8"):
        for file in files:
            if file.endswith('.sh'):
                audits.append({
                    "name": file,
                    "path": os.path.join(root, file)
                })
    return {"audits": audits}

@app.post("/expert/execute")
def expert_execute(
    audits: list = Body(...),
    dry_run: bool = Body(False),
    devices: list = Body(...)
):
    results = execute_on_devices(audits, devices, DEVICE_INFO, dry_run)
    return {"results": results}

@app.get("/backups")
def backups():
    return list_backups()

@app.post("/backups")
def backup():
    result = create_backup()
    # Log the backup action
    log_audit(
        action="Backup",
        status="Completed" if result.get("success", True) else "Failed",
        details=result.get("message", ""),
        system="Server-DB-01"
    )
    return result

@app.get("/history")
def history():
    return get_audit_history()

@app.get("/reports")
def report():
    return {"message": "Report endpoint not implemented."}
