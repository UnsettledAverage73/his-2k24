# Title: CIS Control 18.10.4.1 (L1) - Remediate 'Let Windows Apps Activate with Voice While the System is Locked'

Write-Host "Remediating: CIS Control 18.10.4.1 (L1) - Let Windows Apps Activate with Voice While the System is Locked"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
$regValueName = "LetAppsActivateWithVoiceAboveLock"
$expectedValue = 2

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $expectedValue
Write-Host "Remediated: 'Let Windows Apps Activate with Voice While the System is Locked' is now set to 'Force Deny'." -ForegroundColor Green

