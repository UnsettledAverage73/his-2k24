# Check.ps1 - Check Microsoft network client: Send unencrypted password to third-party SMB servers configuration

$title = "CIS Control 2.3.8.3 - Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'"

# Get the current value of the registry setting
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$regKey = "EnablePlainTextPassword"

# Check if the registry key exists and if the value is set to 0 (Disabled)
$regValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue

if ($regValue) {
    if ($regValue.EnablePlainTextPassword -eq 0) {
        Write-Host "$title - Status: Compliant (Disabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Enabled)"
    }
} else {
    Write-Host "$title - Status: Non-Compliant (Not Configured)"
}

