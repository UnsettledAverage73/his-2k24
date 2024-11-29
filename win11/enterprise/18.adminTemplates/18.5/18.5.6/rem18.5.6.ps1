# Title: CIS Control 18.5.6 (L2) - Ensure 'MSS: (KeepAliveTime)' Is Set to 'Enabled: 300,000 or 5 Minutes'

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$regValueName = "KeepAliveTime"
$expectedValue = 300000

Write-Host "Remediating: CIS Control 18.5.6 (L2) - KeepAliveTime"

# Check if the registry key exists, and set it if needed
if (-not (Test-Path -Path $regPath)) {
    Write-Host "Registry path not found. Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediation completed. KeepAliveTime is now set to 300,000 or 5 minutes." -ForegroundColor Green

