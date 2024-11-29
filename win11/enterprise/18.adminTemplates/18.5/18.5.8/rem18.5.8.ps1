# Title: CIS Control 18.5.8 (L2) - Ensure 'MSS: (PerformRouterDiscovery)' Is Set to 'Disabled'

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$regValueName = "PerformRouterDiscovery"
$expectedValue = 0

Write-Host "Remediating: CIS Control 18.5.8 (L2) - PerformRouterDiscovery"

# Check if the registry key exists, and set it if needed
if (-not (Test-Path -Path $regPath)) {
    Write-Host "Registry path not found. Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediation completed. PerformRouterDiscovery is now set to Disabled." -ForegroundColor Green

