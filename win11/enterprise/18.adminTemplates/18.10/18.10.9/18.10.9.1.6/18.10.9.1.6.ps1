# Title: CIS Control 18.10.9.1.6 (BL) - Check 'Omit Recovery Options' for BitLocker-protected fixed drives

Write-Host "Checking compliance for: CIS Control 18.10.9.1.6 (BL) - Omit Recovery Options"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVHideRecoveryPage"

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq 1) {
        Write-Host "Compliant: 'Omit Recovery Options' is set to 'Enabled: True'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is '$currentValue'. It should be '1' (Enabled: True)." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

