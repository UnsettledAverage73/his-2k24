# Check.ps1
# Description: Verifies if the SNMP Service (SNMP) is Disabled or Not Installed.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: SNMP Service (SNMP) is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: SNMP Service (SNMP) is not set to Disabled. Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "PASS: SNMP Service (SNMP) is not installed." -ForegroundColor Green
}
