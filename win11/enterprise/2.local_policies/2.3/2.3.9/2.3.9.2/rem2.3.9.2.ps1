# Remedi.ps1 - Configure Microsoft network server: Digitally sign communications (always) to 'Enabled'

$title = "CIS Control 2.3.9.2 - Ensure 'Microsoft network server: Digitally sign communications (always)' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "RequireSecuritySignature"

# Ensure the registry path exists
if (-not (Test-Path -Path $regPath)) {
    Write-Host "Registry path does not exist. Creating path..."
    New-Item -Path $regPath -Force
}

# Set the registry value to Enabled (1)
Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Force

Write-Host "$title - Remediation completed. Setting 'Microsoft network server: Digitally sign communications (always)' to 'Enabled'."

