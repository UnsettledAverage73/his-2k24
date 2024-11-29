# Title: CIS Control 18.5.13 (L1) - Remediate 'WarningLevel'

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Eventlog\Security"
$regValueName = "WarningLevel"
$expectedValue = 90

Write-Host "Remediating: CIS Control 18.5.13 (L1) - WarningLevel"

# Check if the registry key exists, and set it if needed
if (-not (Test-Path -Path $regPath)) {
    Write-Host "Registry path not found. Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediation completed. WarningLevel is now set to $expectedValue%." -ForegroundColor Green

