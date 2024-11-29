# Check.ps1
# Description: Verifies if PNRP Machine Name Publication Service (PNRPAutoReg) is Disabled.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\PNRPAutoReg"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: PNRP Machine Name Publication Service (PNRPAutoReg) is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: PNRP Machine Name Publication Service (PNRPAutoReg) is not set to Disabled (`Start` = 4). Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "PASS: PNRP Machine Name Publication Service (PNRPAutoReg) is not installed." -ForegroundColor Green
}
