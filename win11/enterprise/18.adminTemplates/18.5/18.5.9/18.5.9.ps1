# Title: CIS Control 18.5.9 (L1) - Ensure 'SafeDllSearchMode' Is Set to 'Enabled'

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager"
$regValueName = "SafeDllSearchMode"
$expectedValue = 1

Write-Host "Checking compliance for: CIS Control 18.5.9 (L1) - SafeDllSearchMode"

# Check if the registry key exists
if (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Status: Compliant (SafeDllSearchMode is set to Enabled)." -ForegroundColor Green
    } else {
        Write-Host "Status: Non-Compliant (Current value: $currentValue)." -ForegroundColor Red
    }
} else {
    Write-Host "Status: Non-Compliant (SafeDllSearchMode registry key not found)." -ForegroundColor Red
}

