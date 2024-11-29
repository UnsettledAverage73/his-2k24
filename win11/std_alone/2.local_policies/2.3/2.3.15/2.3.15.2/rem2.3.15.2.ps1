# Remedi.ps1 - Configure 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' to 'Enabled'

$title = "CIS Control 2.3.15.2 - Ensure 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager"
$regKey = "ProtectionMode"
$expectedValue = 1

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'Enabled' (value = 1)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. Default permissions for system objects strengthened."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

