# Title: CIS Control 18.5.13 (L1) - Check 'WarningLevel'

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Eventlog\Security"
$regValueName = "WarningLevel"
$expectedValue = 90

Write-Host "Checking compliance for: CIS Control 18.5.13 (L1) - WarningLevel"

# Check if the registry key exists
if (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName).$regValueName
    if ($currentValue -le $expectedValue) {
        Write-Host "Status: Compliant (WarningLevel is set to $currentValue%)." -ForegroundColor Green
    } else {
        Write-Host "Status: Non-Compliant (Current value: $currentValue%)." -ForegroundColor Red
    }
} else {
    Write-Host "Status: Non-Compliant (WarningLevel registry key not found)." -ForegroundColor Red
}

