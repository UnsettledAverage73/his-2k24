# Check.ps1
# Description: Verifies if the World Wide Web Publishing Service (W3SVC) is set to Disabled or Not Installed.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\W3SVC"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: World Wide Web Publishing Service (W3SVC) is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: World Wide Web Publishing Service (W3SVC) is not set to Disabled. Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "PASS: World Wide Web Publishing Service (W3SVC) is not installed." -ForegroundColor Green
}
