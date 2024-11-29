# Title: CIS Control 18.10.9.1.3 (BL) - Check 'Allow Data Recovery Agent' for BitLocker-protected fixed drives

Write-Host "Checking compliance for: CIS Control 18.10.9.1.3 (BL) - Allow Data Recovery Agent"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVManageDRA"

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq 1) {
        Write-Host "Compliant: 'Allow data recovery agent' is set to 'Enabled: True'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is '$currentValue'. It should be '1' (Enabled: True)." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

