# Check.ps1
# Description: Verifies if the Print Spooler (Spooler) service is Disabled.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Spooler"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: Print Spooler service is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Print Spooler service is not set to Disabled (`Start` = 4). Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "PASS: Print Spooler service is not installed." -ForegroundColor Green
}
