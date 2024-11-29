# Check.ps1 - Check Microsoft network client: Digitally sign communications (always) configuration

$title = "CIS Control 2.3.8.1 - Ensure 'Microsoft network client: Digitally sign communications (always)' is set to 'Enabled'"

# Get the current value of the registry setting
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$regKey = "RequireSecuritySignature"

# Check if the registry key exists and if the value is set to 1 (Enabled)
$regValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue

if ($regValue) {
    if ($regValue.RequireSecuritySignature -eq 1) {
        Write-Host "$title - Status: Compliant (Enabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Disabled)"
    }
} else {
    Write-Host "$title - Status: Non-Compliant (Not Configured)"
}

