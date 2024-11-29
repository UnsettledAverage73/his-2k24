# Title: CIS Control 18.5.12 (L2) - Remediate 'TcpMaxDataRetransmissions'

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$regValueName = "TcpMaxDataRetransmissions"
$expectedValue = 3

Write-Host "Remediating: CIS Control 18.5.12 (L2) - TcpMaxDataRetransmissions"

# Check if the registry key exists, and set it if needed
if (-not (Test-Path -Path $regPath)) {
    Write-Host "Registry path not found. Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediation completed. TcpMaxDataRetransmissions is now set to $expectedValue." -ForegroundColor Green

