# Title: CIS Control 18.10.9.1.2 (BL) - Check 'Choose how BitLocker-protected fixed drives can be recovered'

Write-Host "Checking compliance for: CIS Control 18.10.9.1.2 (BL) - BitLocker Recovery Configuration"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVRecovery"

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq 1) {
        Write-Host "Compliant: 'Choose how BitLocker-protected fixed drives can be recovered' is set to 'Enabled'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is '$currentValue'. It should be '1' (Enabled)." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

