# Title: CIS Control 18.10.9.1.5 (BL) - Remediate 'Recovery Key' for BitLocker-protected fixed drives

Write-Host "Remediating: CIS Control 18.10.9.1.5 (BL) - Recovery Key Policy"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVRecoveryKey"
$desiredValue = 1  # Change to '2' if you want to require the 256-bit recovery key instead of allowing it

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord
Write-Host "Remediated: 'Recovery Key' is now set to 'Allow 256-bit recovery key'." -ForegroundColor Green

