# Check.ps1 - Verify Microsoft network server: Digitally sign communications (always) configuration

$title = "CIS Control 2.3.9.2 - Ensure 'Microsoft network server: Digitally sign communications (always)' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "RequireSecuritySignature"

# Retrieve the current registry value
$regValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue

if ($regValue) {
    if ($regValue.RequireSecuritySignature -eq 1) {
        Write-Host "$title - Status: Compliant (Value: Enabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Value: Disabled)"
    }
} else {
    Write-Host "$title - Status: Non-Compliant (Not Configured)"
}

