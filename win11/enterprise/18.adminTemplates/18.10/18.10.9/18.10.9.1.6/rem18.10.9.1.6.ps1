# Title: CIS Control 18.10.9.1.6 (BL) - Remediate 'Omit Recovery Options' for BitLocker-protected fixed drives

Write-Host "Remediating: CIS Control 18.10.9.1.6 (BL) - Omit Recovery Options"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVHideRecoveryPage"
$desiredValue = 1  # Enable: True

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regValueName -Value $desiredValue -Type DWord
Write-Host "Remediated: 'Omit Recovery Options' is now set to 'Enabled: True'." -ForegroundColor Green

