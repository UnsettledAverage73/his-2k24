# Check.ps1
# Description: Verifies if Bluetooth Support Service is disabled.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\bthserv"
$regValue = "Start"
$expectedValue = 4

# Check the current registry value
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: Bluetooth Support Service is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Bluetooth Support Service is not set to Disabled (`Start` = 4). Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for Bluetooth Support Service does not exist." -ForegroundColor Red
}
