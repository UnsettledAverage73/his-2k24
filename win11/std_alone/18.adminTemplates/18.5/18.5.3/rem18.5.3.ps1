# Remedi.ps1 - Configure IPv4 Source Routing Protection to Highest Protection

$title = "CIS Control 18.5.3 (L1) - Ensure 'MSS: (DisableIPSourceRouting) IP Source Routing Protection Level' is set to 'Enabled: Highest protection, source routing is completely disabled'"
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$regKey = "DisableIPSourceRouting"
$expectedValue = 2  # Highest protection

Write-Host "Remediating: $title"

try {
    # Ensure the registry path exists
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path does not exist. Creating it..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry key to the recommended value
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. IPv4 source routing is now set to highest protection (value: 2)."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

