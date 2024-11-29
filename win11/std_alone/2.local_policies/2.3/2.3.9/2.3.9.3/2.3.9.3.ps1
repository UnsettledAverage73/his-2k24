# Check.ps1 - Verify Microsoft network server: Digitally sign communications (always) configuration

$title = "CIS Control 2.3.9.2 - Ensure 'Microsoft network server: Digitally sign communications (always)' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "RequireSecuritySignature"

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop

    if ($regValue.RequireSecuritySignature -eq 1) {
        Write-Host "$title - Status: Compliant (Value: Enabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Value: Disabled)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not configured)"
}

