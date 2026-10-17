from pathlib import Path
import pytest
from cis_audit import detect_platform, discover_scripts, SUPPORTED_TARGETS, BASE_DIR

def test_supported_targets():
    assert "rhel9" in SUPPORTED_TARGETS
    assert "rhel8" in SUPPORTED_TARGETS
    assert "ubuntu" in SUPPORTED_TARGETS

def test_discover_scripts_audit():
    target_dir = BASE_DIR / SUPPORTED_TARGETS["rhel9"] / "5.access_control"
    scripts = discover_scripts(target_dir, mode="audit")
    assert len(scripts) > 0
    for s in scripts:
        assert s.exists()
        assert s.name in ("check.sh", "remedi.sh") or s.name.endswith(".sh")

def test_discover_scripts_remediation():
    target_dir = BASE_DIR / SUPPORTED_TARGETS["rhel9"] / "5.access_control"
    scripts = discover_scripts(target_dir, mode="remediate")
    assert len(scripts) > 0
    for s in scripts:
        assert s.exists()
        assert "remedi" in s.name or s.name.endswith(".sh")

def test_detect_platform():
    # Calling detect_platform on current system should return a string or None
    platform = detect_platform()
    assert platform is None or isinstance(platform, str)
