# Remedi.ps1 - Remediate Microsoft network client: Digitally sign communications (always) configuration

$title = "CIS Control 2.3.8.1 - Ensure 'Microsoft network client: Digitally sign communications (always)' is set to 'Enabled'"

# Define the registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$regKey = "RequireSecuritySignature"

# Ensure the registry path exists
if (-not (Test-Path -Path $regPath)) {
    Write-Host "Registry path does not exist. Creating path..."
    New-Item -Path $regPath -Force
}

# Set the registry value to 1 (Enabled) for SMB packet signing
Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Force

Write-Host "$title - Remediation completed. Setting 'Microsoft network client: Digitally sign communications (always)' to 'Enabled'."

