# Remedi.ps1 - Configure Network access: Do not allow storage of passwords and credentials for network authentication to 'Enabled'

$title = "CIS Control 2.3.10.4 - Ensure 'Network access: Do not allow storage of passwords and credentials for network authentication' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "DisableDomainCreds"

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to Enabled (1)
    Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Force
    Write-Host "$title - Remediation completed. Setting 'Network access: Do not allow storage of passwords and credentials for network authentication' to 'Enabled'."
    Write-Host "Note: A system restart is required for this change to take effect."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

