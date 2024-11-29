# remedi.ps1
# Script to disable 'Bluetooth Audio Gateway Service (BTAGService)'.

Write-Host "Disabling 'Bluetooth Audio Gateway Service (BTAGService)'..." -ForegroundColor Cyan

# Registry path and value for the service
$servicePath = "HKLM:\SYSTEM\CurrentControlSet\Services\BTAGService"
$propertyName = "Start"
$desiredValue = 4  # Disabled

# Check if the registry path exists
if (-Not (Test-Path -Path $servicePath)) {
    Write-Host "'Bluetooth Audio Gateway Service (BTAGService)' registry key not found. Skipping remediation." -ForegroundColor Yellow
    exit
}

# Set the service to Disabled
try {
    Set-ItemProperty -Path $servicePath -Name $propertyName -Value $desiredValue
    Write-Host "'Bluetooth Audio Gateway Service (BTAGService)' has been set to 'Disabled' successfully." -ForegroundColor Green
} catch {
    Write-Host "Error disabling 'Bluetooth Audio Gateway Service (BTAGService)': $_" -ForegroundColor Red
}
