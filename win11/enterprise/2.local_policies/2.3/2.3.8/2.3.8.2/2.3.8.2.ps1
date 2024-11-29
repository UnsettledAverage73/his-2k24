# Check.ps1 - Check Microsoft network client: Digitally sign communications (if server agrees) configuration

$title = "CIS Control 2.3.8.2 - Ensure 'Microsoft network client: Digitally sign communications (if server agrees)' is set to 'Enabled'"

# Get the current value of the registry setting
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$regKey = "EnableSecuritySignature"

# Check if the registry key exists and if the value is set to 1 (Enabled)
$regValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue

if ($regValue) {
    if ($regValue.EnableSecuritySignature -eq 1) {
        Write-Host "$title - Status: Compliant (Enabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Disabled)"
    }
} else {
    Write-Host "$title - Status: Non-Compliant (Not Configured)"
}

