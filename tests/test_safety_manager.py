import os
import tempfile
import shutil
from pathlib import Path
import pytest
from cis_audit import ProductionSafetyManager

def test_production_safety_manager_init():
    mgr = ProductionSafetyManager()
    assert mgr.backup_root.exists()

def test_snapshot_creation_and_manifest():
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        mgr = ProductionSafetyManager(backup_root=temp_path)
        
        # Create a mock target file to backup
        mock_target = temp_path / "mock_file.conf"
        mock_target.write_text("TEST_CONFIG=true\n")
        
        # Run snapshot creation
        snapshot_dir = mgr.create_snapshot(target_paths=[str(mock_target)])
        assert snapshot_dir.exists()
        
        manifest_path = snapshot_dir / "manifest.json"
        assert manifest_path.exists()
        
        # Verify copied file in snapshot
        rel_path = mock_target.relative_to("/")
        backed_up_file = snapshot_dir / rel_path
        assert backed_up_file.exists()
        assert backed_up_file.read_text() == "TEST_CONFIG=true\n"

def test_snapshot_rollback():
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        mgr = ProductionSafetyManager(backup_root=temp_path)
        
        # Create initial target file
        mock_file = temp_path / "sys_config.conf"
        mock_file.write_text("ORIGINAL_VALUE=1\n")
        
        # Snapshot it
        snapshot_dir = mgr.create_snapshot(target_paths=[str(mock_file)])
        
        # Mutate the file (simulate bad remediation)
        mock_file.write_text("CORRUPTED_VALUE=999\n")
        assert mock_file.read_text() == "CORRUPTED_VALUE=999\n"
        
        # Rollback
        success = mgr.rollback(target_snapshot=snapshot_dir)
        assert success is True
        assert mock_file.read_text() == "ORIGINAL_VALUE=1\n"

def test_system_health_verification():
    mgr = ProductionSafetyManager()
    is_healthy, issues = mgr.verify_system_health()
    # verify_system_health returns a tuple (bool, list)
    assert isinstance(is_healthy, bool)
    assert isinstance(issues, list)
