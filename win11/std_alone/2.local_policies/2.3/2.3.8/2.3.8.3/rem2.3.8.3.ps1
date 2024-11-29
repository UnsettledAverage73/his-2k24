# Remedi.ps1 - Remediate Microsoft network client: Send unencrypted password to third-party SMB servers configuration

$title = "CIS Control 2.3.8.3 - Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'"

# Define the registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$regKey = "EnablePlainTextPassword"

# Ensure the registry path exists
if (-not (Test-Path -Path $regPath)) {
    Write-Host "Registry path does not exist. Creating path..."
    New-Item -Path $regPath -Force
}

# Set the registry value to 0 (Disabled) for preventing unencrypted password transmission
Set-ItemProperty -Path $regPath -Name $regKey -Value 0 -Force

Write-Host "$title - Remediation completed. Setting 'Microsoft network client: Send unencrypted password to third-party SMB servers' to 'Disabled'."

