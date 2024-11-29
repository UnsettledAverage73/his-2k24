# Check.ps1
# Description: Verifies if the Xbox Live Networking Service (XboxNetApiSvc) is set to Disabled.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: Xbox Live Networking Service (XboxNetApiSvc) is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Xbox Live Networking Service (XboxNetApiSvc) is not set to Disabled. Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Xbox Live Networking Service (XboxNetApiSvc) is not installed." -ForegroundColor Yellow
}
