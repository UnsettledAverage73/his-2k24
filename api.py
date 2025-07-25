from fastapi import FastAPI, HTTPException, Body, WebSocket, WebSocketDisconnect, Depends, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from datetime import datetime, timedelta
from typing import List, Dict, Optional
import uuid
import os
import subprocess
import psutil
import platform
from pathlib import Path
import paramiko
import asyncio
import json
import hashlib
import secrets
import jwt
from contextlib import contextmanager
import socket
import time
import logging
import re
import sys

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI()

# Security Configuration
SECRET_KEY = os.getenv("SECRET_KEY", secrets.token_urlsafe(32))
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Admin credentials (in production, use database)
ADMIN_USERS = {
    "admin": {
        "password_hash": hashlib.sha256("admin123".encode()).hexdigest(),  # Change this!
        "permissions": ["execute", "monitor", "manage"]
    },
    "auditor": {
        "password_hash": hashlib.sha256("audit123".encode()).hexdigest(),  # Change this!
        "permissions": ["execute", "monitor"]
    }
}

security = HTTPBearer()

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure properly in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# WebSocket Connection Manager
class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[str, WebSocket] = {}
        self.execution_sessions: Dict[str, Dict] = {}

    async def connect(self, websocket: WebSocket, session_id: str, user: str):
        await websocket.accept()
        self.active_connections[session_id] = websocket
        logger.info(f"WebSocket connected: {user} - {session_id}")

    def disconnect(self, session_id: str):
        if session_id in self.active_connections:
            del self.active_connections[session_id]
        if session_id in self.execution_sessions:
            del self.execution_sessions[session_id]

    async def send_message(self, session_id: str, message: dict):
        if session_id in self.active_connections:
            try:
                await self.active_connections[session_id].send_text(json.dumps(message))
            except Exception as e:
                logger.error(f"Failed to send message to {session_id}: {e}")
                self.disconnect(session_id)

    async def broadcast_to_all(self, message: dict):
        for session_id in list(self.active_connections.keys()):
            await self.send_message(session_id, message)

manager = ConnectionManager()

# Enhanced Device Configuration with Security
DEVICE_INFO = {
    "local": {
        "name": "Web Application Server",
        "type": "local",
        "status": "connected",
        "security_level": "high",
        "allowed_scripts": ["audit", "monitoring", "backup"],
        "restricted_commands": ["rm -rf", "format", "dd", "mkfs", "> /dev/"]
    },
    "dev1": {
        "name": "Development Server 1",
        "host": "192.168.1.101",
        "port": 22,
        "username": "sysadmin",
        "password": "secure_password_here",  # Use SSH keys in production
        "type": "remote",
        "status": "disconnected",
        "security_level": "medium",
        "allowed_scripts": ["audit", "monitoring"],
        "restricted_commands": ["rm -rf", "shutdown", "reboot"]
    },
    "prod1": {
        "name": "Production Server 1",
        "host": "192.168.1.200",
        "port": 22,
        "username": "admin",
        "password": "production_password",  # Use SSH keys in production
        "type": "remote",
        "status": "disconnected",
        "security_level": "critical",
        "allowed_scripts": ["monitoring"],  # Only monitoring allowed on production
        "restricted_commands": ["rm", "del", "format", "shutdown", "reboot", "kill"]
    }
}

@app.get("/devices")
def get_devices():
    # In a real app, you might enrich this with more dynamic data
    devices = []
    for device_id, info in DEVICE_INFO.items():
        devices.append({
            "id": device_id,
            "name": device_id.capitalize(),
            **info
        })
    return {"devices": devices}

# --- Audit History ---
AUDIT_HISTORY = []

# Security Functions
def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def verify_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    try:
        payload = jwt.decode(credentials.credentials, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise HTTPException(status_code=401, detail="Invalid authentication credentials")
        return payload
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid authentication credentials")

def check_permission(required_permission: str):
    def permission_checker(token_data: dict = Depends(verify_token)):
        username = token_data.get("sub")
        user_permissions = token_data.get("permissions", [])
        if required_permission not in user_permissions:
            raise HTTPException(status_code=403, detail="Insufficient permissions")
        return username
    return permission_checker

# Security Validation Functions
def validate_script_content(script_content: str, device_config: dict) -> tuple[bool, str]:
    """Validate script content for security risks"""
    restricted_commands = device_config.get("restricted_commands", [])
    security_level = device_config.get("security_level", "medium")
    
    # Check for restricted commands
    for restricted in restricted_commands:
        if restricted.lower() in script_content.lower():
            return False, f"Restricted command detected: {restricted}"
    
    # Additional security checks based on security level
    if security_level == "critical":
        # Extra strict validation for production systems
        dangerous_patterns = [
            r'sudo\s+rm',
            r'chmod\s+777',
            r'>/dev/sd[a-z]',
            r'dd\s+if=',
            r'mkfs\.',
            r'fdisk',
            r'parted'
        ]
        for pattern in dangerous_patterns:
            if re.search(pattern, script_content, re.IGNORECASE):
                return False, f"Potentially dangerous command pattern detected: {pattern}"
    
    return True, "Script validation passed"

def generate_execution_token(devices: list, scripts: list, user: str) -> str:
    """Generate a secure execution token"""
    data = {
        "devices": devices,
        "scripts": scripts,
        "user": user,
        "timestamp": datetime.utcnow().isoformat(),
        "nonce": secrets.token_hex(8)
    }
    return hashlib.sha256(json.dumps(data, sort_keys=True).encode()).hexdigest()

# Enhanced SSH Connection with Security
@contextmanager
def secure_ssh_connection(device_config: dict, timeout=10):
    """Secure SSH connection with enhanced error handling"""
    ssh = None
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        # Enhanced connection with security options
        ssh.connect(
            hostname=device_config["host"],
            port=device_config.get("port", 22),
            username=device_config["username"],
            password=device_config["password"],
            timeout=timeout,
            auth_timeout=timeout,
            banner_timeout=timeout,
            compress=True,
            look_for_keys=True,  # Try SSH keys first
            allow_agent=True
        )
        yield ssh
    except Exception as e:
        logger.error(f"SSH connection failed to {device_config.get('host', 'unknown')}: {e}")
        raise
    finally:
        if ssh:
            ssh.close()

# Enhanced Execution Functions
async def execute_script_with_monitoring(
    device_id: str, 
    script_path: str, 
    session_id: str,
    dry_run: bool = False
) -> dict:
    """Execute script with real-time WebSocket monitoring"""
    device_config = DEVICE_INFO.get(device_id)
    if not device_config:
        return {"success": False, "error": f"Device {device_id} not found"}
    
    # Send start notification
    await manager.send_message(session_id, {
        "type": "execution_start",
        "device": device_id,
        "script": script_path,
        "timestamp": datetime.now().isoformat()
    })
    
    try:
        if device_id == "local":
            result = await execute_local_with_monitoring(script_path, session_id, dry_run)
        else:
            result = await execute_remote_with_monitoring(device_config, script_path, session_id, dry_run)
        
        # Send completion notification
        await manager.send_message(session_id, {
            "type": "execution_complete",
            "device": device_id,
            "script": script_path,
            "success": result["success"],
            "timestamp": datetime.now().isoformat()
        })
        
        return result
        
    except Exception as e:
        error_msg = str(e)
        await manager.send_message(session_id, {
            "type": "execution_error",
            "device": device_id,
            "script": script_path,
            "error": error_msg,
            "timestamp": datetime.now().isoformat()
        })
        return {"success": False, "error": error_msg}

async def execute_local_with_monitoring(script_path: str, session_id: str, dry_run: bool) -> dict:
    """Execute script locally with real-time output"""
    if dry_run:
        await manager.send_message(session_id, {
            "type": "output",
            "device": "local",
            "message": f"DRY RUN: Would execute {script_path}",
            "timestamp": datetime.now().isoformat()
        })
        return {"success": True, "output": "Dry run completed", "error": ""}
    
    try:
        # Read and validate script
        with open(script_path, 'r') as f:
            script_content = f.read()
        
        is_valid, validation_msg = validate_script_content(script_content, DEVICE_INFO["local"])
        if not is_valid:
            return {"success": False, "error": f"Security validation failed: {validation_msg}"}
        
        # Execute with real-time output
        process = subprocess.Popen(
            ["bash", script_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1,
            universal_newlines=True
        )
        
        output_lines = []
        error_lines = []
        
        # Monitor output in real-time
        while True:
            output = process.stdout.readline()
            if output:
                output_lines.append(output.strip())
                await manager.send_message(session_id, {
                    "type": "output",
                    "device": "local",
                    "message": output.strip(),
                    "timestamp": datetime.now().isoformat()
                })
            
            error = process.stderr.readline()
            if error:
                error_lines.append(error.strip())
                await manager.send_message(session_id, {
                    "type": "error",
                    "device": "local",
                    "message": error.strip(),
                    "timestamp": datetime.now().isoformat()
                })
            
            if output == '' and error == '' and process.poll() is not None:
                break
        
        return_code = process.wait()
        
        return {
            "success": return_code == 0,
            "output": "\n".join(output_lines),
            "error": "\n".join(error_lines),
            "return_code": return_code
        }
        
    except Exception as e:
        return {"success": False, "error": str(e)}

async def execute_remote_with_monitoring(device_config: dict, script_path: str, session_id: str, dry_run: bool) -> dict:
    """Execute script on remote device with monitoring"""
    if dry_run:
        await manager.send_message(session_id, {
            "type": "output",
            "device": device_config.get("name", "remote"),
            "message": f"DRY RUN: Would execute {script_path} on {device_config['host']}",
            "timestamp": datetime.now().isoformat()
        })
        return {"success": True, "output": "Dry run completed", "error": ""}
    
    try:
        # Read and validate script
        with open(script_path, 'r') as f:
            script_content = f.read()
        
        is_valid, validation_msg = validate_script_content(script_content, device_config)
        if not is_valid:
            return {"success": False, "error": f"Security validation failed: {validation_msg}"}
        
        with secure_ssh_connection(device_config) as ssh:
            # Create temporary script on remote system
            temp_script = f"/tmp/audit_script_{int(time.time())}.sh"
            
            # Upload script
            stdin, stdout, stderr = ssh.exec_command(f"cat > {temp_script}")
            stdin.write(script_content)
            stdin.channel.shutdown_write()
            
            # Make executable
            ssh.exec_command(f"chmod +x {temp_script}")
            
            # Execute with monitoring
            stdin, stdout, stderr = ssh.exec_command(f"bash {temp_script}")
            
            # Stream output
            output_lines = []
            error_lines = []
            
            for line in stdout:
                line = line.strip()
                output_lines.append(line)
                await manager.send_message(session_id, {
                    "type": "output",
                    "device": device_config.get("name", "remote"),
                    "message": line,
                    "timestamp": datetime.now().isoformat()
                })
            
            for line in stderr:
                line = line.strip()
                error_lines.append(line)
                await manager.send_message(session_id, {
                    "type": "error",
                    "device": device_config.get("name", "remote"),
                    "message": line,
                    "timestamp": datetime.now().isoformat()
                })
            
            exit_code = stdout.channel.recv_exit_status()
            
            # Cleanup
            ssh.exec_command(f"rm -f {temp_script}")
            
            return {
                "success": exit_code == 0,
                "output": "\n".join(output_lines),
                "error": "\n".join(error_lines),
                "return_code": exit_code
            }
            
    except Exception as e:
        return {"success": False, "error": str(e)}

# API Endpoints

@app.post("/auth/login")
def login(username: str = Body(...), password: str = Body(...)):
    """Secure login endpoint"""
    user = ADMIN_USERS.get(username)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    password_hash = hashlib.sha256(password.encode()).hexdigest()
    if password_hash != user["password_hash"]:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": username, "permissions": user["permissions"]},
        expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "permissions": user["permissions"]
    }

@app.get("/devices/status")
def get_devices_status(user: str = Depends(check_permission("monitor"))):
    """Get status of all configured devices"""
    async def check_device_connectivity():
        for device_id, config in DEVICE_INFO.items():
            if device_id == "local":
                config["status"] = "connected"
            else:
                try:
                    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                    sock.settimeout(5)
                    result = sock.connect_ex((config["host"], config.get("port", 22)))
                    sock.close()
                    config["status"] = "connected" if result == 0 else "disconnected"
                except:
                    config["status"] = "disconnected"
                config["last_checked"] = datetime.now().isoformat()
    
    asyncio.create_task(check_device_connectivity())
    return {"devices": DEVICE_INFO}

@app.post("/expert/execute/prepare")
def prepare_execution(
    audits: list = Body(...),
    devices: list = Body(...),
    user: str = Depends(check_permission("execute"))
):
    """Prepare execution with security validation"""
    # Validate devices
    invalid_devices = [d for d in devices if d not in DEVICE_INFO]
    if invalid_devices:
        raise HTTPException(status_code=400, detail=f"Invalid devices: {invalid_devices}")
    
    # Validate scripts
    missing_scripts = []
    for script in audits:
        if not os.path.exists(script):
            missing_scripts.append(script)
    
    if missing_scripts:
        raise HTTPException(status_code=400, detail=f"Scripts not found: {missing_scripts}")
    
    # Generate execution token
    execution_token = generate_execution_token(devices, audits, user)
    
    # Prepare security summary
    security_summary = []
    for device_id in devices:
        device_config = DEVICE_INFO[device_id]
        security_summary.append({
            "device": device_id,
            "name": device_config.get("name", device_id),
            "security_level": device_config.get("security_level", "medium"),
            "type": device_config.get("type", "unknown")
        })
    
    return {
        "execution_token": execution_token,
        "security_summary": security_summary,
        "total_executions": len(audits) * len(devices),
        "requires_confirmation": True
    }

@app.post("/expert/execute/confirmed")
async def execute_confirmed(
    execution_token: str = Body(...),
    audits: list = Body(...),
    devices: list = Body(...),
    dry_run: bool = Body(False),
    user: str = Depends(check_permission("execute"))
):
    """Execute scripts after confirmation with real-time monitoring"""
    # Verify execution token
    expected_token = generate_execution_token(devices, audits, user)
    if execution_token != expected_token:
        raise HTTPException(status_code=400, detail="Invalid execution token")
    
    # Generate session ID for WebSocket monitoring
    session_id = str(uuid.uuid4())
    
    # Store execution session
    manager.execution_sessions[session_id] = {
        "user": user,
        "devices": devices,
        "scripts": audits,
        "dry_run": dry_run,
        "started": datetime.now().isoformat()
    }
    
    try:
        results = []
        
        # Execute on each device
        for device_id in devices:
            for script_path in audits:
                result = await execute_script_with_monitoring(device_id, script_path, session_id, dry_run)
                results.append({
                    "device": device_id,
                    "script": script_path,
                    **result
                })
        
        return {
            "session_id": session_id,
            "results": results,
            "summary": {
                "total": len(results),
                "successful": len([r for r in results if r["success"]]),
                "failed": len([r for r in results if not r["success"]]),
                "dry_run": dry_run
            }
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.websocket("/ws/{session_id}")
async def websocket_endpoint(websocket: WebSocket, session_id: str):
    """WebSocket endpoint for real-time monitoring"""
    # In production, add token-based authentication for WebSocket
    await manager.connect(websocket, session_id, "admin")  # Simplified for demo
    
    try:
        while True:
            # Keep connection alive and handle client messages
            data = await websocket.receive_text()
            message = json.loads(data)
            
            if message.get("type") == "ping":
                await websocket.send_text(json.dumps({"type": "pong"}))
            elif message.get("type") == "get_status":
                # Send current execution status
                if session_id in manager.execution_sessions:
                    session_info = manager.execution_sessions[session_id]
                    await websocket.send_text(json.dumps({
                        "type": "session_status",
                        "session": session_info
                    }))
                    
    except WebSocketDisconnect:
        manager.disconnect(session_id)
    except Exception as e:
        logger.error(f"WebSocket error: {e}")
        manager.disconnect(session_id)

# Health and monitoring endpoints
@app.get("/health")
def health_check():
    return {"status": "ok", "timestamp": datetime.now().isoformat()}

@app.get("/system-status")
def system_status(user: str = Depends(check_permission("monitor"))):
    return {
        "cpu": psutil.cpu_percent(),
        "memory": psutil.virtual_memory().percent,
        "disk": psutil.disk_usage('/').percent,
        "system": f"{platform.system()} {platform.release()}",
        "active_sessions": len(manager.active_connections)
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)