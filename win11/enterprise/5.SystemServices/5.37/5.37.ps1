# Check.ps1
# Description: Verifies if the Windows Push Notifications System Service (WpnService) is Disabled.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\WpnService"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: Windows Push Notifications System Service (WpnService) is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Windows Push Notifications System Service (WpnService) is not set to Disabled. Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Windows Push Notifications System Service (WpnService) registry key does not exist. The service may not be installed." -ForegroundColor Yellow
}
