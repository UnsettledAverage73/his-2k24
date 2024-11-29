# Remedi.ps1 - Configure 'NetBT NodeType configuration' to 'Enabled: P-node (recommended)'

$title = "CIS Control 18.4.7 (L1) - Ensure 'NetBT NodeType configuration' is set to 'Enabled: P-node (recommended)'"
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters"
$regKey = "NodeType"
$expectedValue = 2  # P-node (point-to-point)

Write-Host "Remediating: $title"

try {
    # Ensure the registry path exists
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path does not exist. Creating it..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry key to the recommended value
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. NodeType is now set to P-node (value: 2)."
    Write-Host "Restart the system to apply the changes."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

