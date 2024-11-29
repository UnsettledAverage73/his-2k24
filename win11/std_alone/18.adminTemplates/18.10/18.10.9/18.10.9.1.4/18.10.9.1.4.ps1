# Title: CIS Control 18.10.9.1.4 (BL) - Check 'Recovery Password' for BitLocker-protected fixed drives

Write-Host "Checking compliance for: CIS Control 18.10.9.1.4 (BL) - Recovery Password Policy"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVRecoveryPassword"

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq 1) {
        Write-Host "Compliant: 'Recovery Password' is set to 'Allow 48-digit recovery password'." -ForegroundColor Green
    } elseif ($currentValue -eq 2) {
        Write-Host "Compliant: 'Recovery Password' is set to 'Require 48-digit recovery password'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is '$currentValue'. It should be '1' (Allow) or '2' (Require)." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

