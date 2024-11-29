# Title: CIS Control 18.10.9.1.5 (BL) - Check 'Recovery Key' for BitLocker-protected fixed drives

Write-Host "Checking compliance for: CIS Control 18.10.9.1.5 (BL) - Recovery Key Policy"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVRecoveryKey"

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq 1) {
        Write-Host "Compliant: 'Recovery Key' is set to 'Allow 256-bit recovery key'." -ForegroundColor Green
    } elseif ($currentValue -eq 2) {
        Write-Host "Compliant: 'Recovery Key' is set to 'Require 256-bit recovery key'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is '$currentValue'. It should be '1' (Allow) or '2' (Require)." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

