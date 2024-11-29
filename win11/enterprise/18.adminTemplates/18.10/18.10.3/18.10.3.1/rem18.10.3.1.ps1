# Title: CIS Control 18.10.3.1 (L2) - Remediate 'Allow a Windows App to Share Application Data Between Users'

Write-Host "Remediating: CIS Control 18.10.3.1 (L2) - Allow a Windows App to Share Application Data Between Users"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\AppModel\StateManager"
$regValueName = "AllowSharedLocalAppData"
$expectedValue = 0

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediated: 'Allow a Windows App to Share Application Data Between Users' is now Disabled." -ForegroundColor Green

