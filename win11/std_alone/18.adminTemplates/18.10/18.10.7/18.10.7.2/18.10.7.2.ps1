# Title: CIS Control 18.10.7.2 (L1) - Check 'Set the Default Behavior for AutoRun'

Write-Host "Checking compliance for: CIS Control 18.10.7.2 (L1) - Set the Default Behavior for AutoRun"

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$regValueName = "NoAutorun"
$expectedValue = 1

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Compliant: 'Set the Default Behavior for AutoRun' is set to 'Enabled: Do not execute any autorun commands'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is $currentValue." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

