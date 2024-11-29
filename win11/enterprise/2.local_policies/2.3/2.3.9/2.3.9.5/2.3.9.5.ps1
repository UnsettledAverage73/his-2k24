# Check.ps1 - Verify Microsoft network server: Disconnect clients when logon hours expire configuration

$title = "CIS Control 2.3.9.4 - Ensure 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "enableforcedlogoff"

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop

    if ($regValue.enableforcedlogoff -eq 1) {
        Write-Host "$title - Status: Compliant (Value: Enabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Value: Disabled or Not Configured)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not configured)"
}

