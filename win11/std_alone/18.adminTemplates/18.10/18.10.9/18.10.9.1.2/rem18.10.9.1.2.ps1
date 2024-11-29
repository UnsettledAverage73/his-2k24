# Title: CIS Control 18.10.9.1.2 (BL) - Remediate 'Choose how BitLocker-protected fixed drives can be recovered'

Write-Host "Remediating: CIS Control 18.10.9.1.2 (BL) - BitLocker Recovery Configuration"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVRecovery"
$desiredValue = 1

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord
Write-Host "Remediated: 'Choose how BitLocker-protected fixed drives can be recovered' is now set to 'Enabled'." -ForegroundColor Green

