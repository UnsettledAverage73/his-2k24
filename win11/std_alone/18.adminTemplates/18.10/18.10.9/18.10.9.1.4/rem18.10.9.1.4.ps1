# Title: CIS Control 18.10.9.1.4 (BL) - Remediate 'Recovery Password' for BitLocker-protected fixed drives

Write-Host "Remediating: CIS Control 18.10.9.1.4 (BL) - Recovery Password Policy"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVRecoveryPassword"
$desiredValue = 1  # Change to '2' if you want to require the 48-digit password instead of allowing it

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord
Write-Host "Remediated: 'Recovery Password' is now set to 'Allow 48-digit recovery password'." -ForegroundColor Green

