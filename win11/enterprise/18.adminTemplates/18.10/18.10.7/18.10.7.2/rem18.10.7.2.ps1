# Title: CIS Control 18.10.7.2 (L1) - Remediate 'Set the Default Behavior for AutoRun'

Write-Host "Remediating: CIS Control 18.10.7.2 (L1) - Set the Default Behavior for AutoRun"

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$regValueName = "NoAutorun"
$expectedValue = 1

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediated: 'Set the Default Behavior for AutoRun' is now set to 'Enabled: Do not execute any autorun commands'." -ForegroundColor Green

