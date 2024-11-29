# Title: CIS Control 18.10.3.1 (L2) - Check 'Allow a Windows App to Share Application Data Between Users'

Write-Host "Checking compliance for: CIS Control 18.10.3.1 (L2) - Allow a Windows App to Share Application Data Between Users"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\AppModel\StateManager"
$regValueName = "AllowSharedLocalAppData"
$expectedValue = 0

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Compliant: 'Allow a Windows App to Share Application Data Between Users' is Disabled." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is $currentValue." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

