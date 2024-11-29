# Title: CIS Control 18.5.7 (L1) - Ensure 'MSS: (NoNameReleaseOnDemand)' Is Set to 'Enabled'

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters"
$regValueName = "NoNameReleaseOnDemand"
$expectedValue = 1

Write-Host "Remediating: CIS Control 18.5.7 (L1) - NoNameReleaseOnDemand"

# Check if the registry key exists, and set it if needed
if (-not (Test-Path -Path $regPath)) {
    Write-Host "Registry path not found. Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediation completed. NoNameReleaseOnDemand is now set to Enabled." -ForegroundColor Green

