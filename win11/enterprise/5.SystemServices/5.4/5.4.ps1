# Check.ps1
# Description: Verifies if Downloaded Maps Manager service is disabled.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\MapsBroker"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: Downloaded Maps Manager service is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Downloaded Maps Manager service is not set to Disabled (`Start` = 4). Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Downloaded Maps Manager service registry path does not exist. It may already be removed." -ForegroundColor Yellow
}
