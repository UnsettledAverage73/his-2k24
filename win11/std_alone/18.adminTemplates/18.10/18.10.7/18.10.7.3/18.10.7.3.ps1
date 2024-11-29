# Title: CIS Control 18.10.7.3 (L1) - Check 'Turn Off Autoplay'

Write-Host "Checking compliance for: CIS Control 18.10.7.3 (L1) - Turn Off Autoplay"

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$regValueName = "NoDriveTypeAutoRun"
$expectedValue = 255  # Value for 'Enabled: All Drives'

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Compliant: 'Turn Off Autoplay' is set to 'Enabled: All Drives'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is $currentValue. Expected value is $expectedValue." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

