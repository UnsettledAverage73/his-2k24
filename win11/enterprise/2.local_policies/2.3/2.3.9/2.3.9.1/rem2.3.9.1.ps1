# Remedi.ps1 - Remediate Microsoft network server: Amount of idle time required before suspending session configuration

$title = "CIS Control 2.3.9.1 - Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s)'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "AutoDisconnect"

# Ensure the registry path exists
if (-not (Test-Path -Path $regPath)) {
    Write-Host "Registry path does not exist. Creating path..."
    New-Item -Path $regPath -Force
}

# Set the registry value to 15 minutes
Set-ItemProperty -Path $regPath -Name $regKey -Value 15 -Force

Write-Host "$title - Remediation completed. Setting 'Microsoft network server: Amount of idle time required before suspending session' to '15 minutes'."

