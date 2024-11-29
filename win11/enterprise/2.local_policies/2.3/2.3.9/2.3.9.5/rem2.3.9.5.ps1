# Remedi.ps1 - Configure Microsoft network server: Disconnect clients when logon hours expire to 'Enabled'

$title = "CIS Control 2.3.9.4 - Ensure 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "enableforcedlogoff"

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to Enabled (1)
    Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Force
    Write-Host "$title - Remediation completed. Setting 'Microsoft network server: Disconnect clients when logon hours expire' to 'Enabled'."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

