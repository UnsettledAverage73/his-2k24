# Title: CIS Control 18.5.7 (L1) - Ensure 'MSS: (NoNameReleaseOnDemand)' Is Set to 'Enabled'

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters"
$regValueName = "NoNameReleaseOnDemand"
$expectedValue = 1

Write-Host "Checking compliance for: CIS Control 18.5.7 (L1) - NoNameReleaseOnDemand"

# Check if the registry key exists
if (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Status: Compliant (NoNameReleaseOnDemand is set to Enabled)." -ForegroundColor Green
    } else {
        Write-Host "Status: Non-Compliant (Current value: $currentValue)." -ForegroundColor Red
    }
} else {
    Write-Host "Status: Non-Compliant (NoNameReleaseOnDemand registry key not found)." -ForegroundColor Red
}

