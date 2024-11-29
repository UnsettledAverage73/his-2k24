# Check.ps1
# Description: Verifies if the Web Management Service (WMSvc) is Disabled or Not Installed.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\WMSvc"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: Web Management Service (WMSvc) is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Web Management Service (WMSvc) is not set to Disabled. Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Web Management Service (WMSvc) is not installed. No action required." -ForegroundColor Yellow
}
