# Title: CIS Control 18.10.4.1 (L1) - Check 'Let Windows Apps Activate with Voice While the System is Locked'

Write-Host "Checking compliance for: CIS Control 18.10.4.1 (L1) - Let Windows Apps Activate with Voice While the System is Locked"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
$regValueName = "LetAppsActivateWithVoiceAboveLock"
$expectedValue = 2

if (Test-Path -Path $regPath)) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Compliant: 'Let Windows Apps Activate with Voice While the System is Locked' is set to 'Force Deny'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is $currentValue." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

