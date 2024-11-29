# Remedi.ps1 - Configure 'Configure SMB v1 server' to 'Disabled'

$title = "CIS Control 18.4.4 (L1) - Ensure 'Configure SMB v1 server' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$regKey = "SMB1"
$expectedValue = 0  # 0 = Disabled

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'Disabled' (value = 0)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. SMBv1 is now disabled."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

