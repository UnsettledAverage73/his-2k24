# Title: CIS Control 18.10.5.1 (L1) - Check 'Allow Microsoft Accounts to be Optional'

Write-Host "Checking compliance for: CIS Control 18.10.5.1 (L1) - Allow Microsoft Accounts to be Optional"

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "MSAOptional"
$expectedValue = 1

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Compliant: 'Allow Microsoft Accounts to be Optional' is set to 'Enabled'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is $currentValue." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

