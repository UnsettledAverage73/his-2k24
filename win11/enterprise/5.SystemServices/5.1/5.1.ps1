# check.ps1
# Script to verify if 'Bluetooth Audio Gateway Service (BTAGService)' is set to 'Disabled'.

Write-Host "Checking 'Bluetooth Audio Gateway Service (BTAGService)' configuration..." -ForegroundColor Cyan

# Registry path and value for the service
$servicePath = "HKLM:\SYSTEM\CurrentControlSet\Services\BTAGService"
$propertyName = "Start"

# Check if the service registry key exists
if (Test-Path -Path $servicePath) {
    $currentValue = (Get-ItemProperty -Path $servicePath -Name $propertyName -ErrorAction SilentlyContinue).$propertyName
    if ($currentValue -eq 4) {
        Write-Host "'Bluetooth Audio Gateway Service (BTAGService)' is set to 'Disabled'. Compliance: PASS" -ForegroundColor Green
    } else {
        Write-Host "'Bluetooth Audio Gateway Service (BTAGService)' is not set to 'Disabled'. Current value: $currentValue. Compliance: FAIL" -ForegroundColor Red
    }
} else {
    Write-Host "'Bluetooth Audio Gateway Service (BTAGService)' registry key not found. Compliance: FAIL" -ForegroundColor Red
}
