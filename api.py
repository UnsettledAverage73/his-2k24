from fastapi import FastAPI, HTTPException, Body
from fastapi.middleware.cors import CORSMiddleware
from inference import (
    get_system_status, execute_script, run_complete_check, get_processes,
    create_backup, list_backups, delete_backup, get_audit_history, execute_on_devices
)
import os

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
        return result
    except Exception as e:
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
    # Simulate audit scripts (replace with directory scan if needed)
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
    return create_backup()

@app.get("/history")
def history():
    return get_audit_history() 