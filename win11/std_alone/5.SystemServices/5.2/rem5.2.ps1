# Remedi.ps1
# Description: Disables the Bluetooth Support Service.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\bthserv"
$regValue = "Start"
$disableValue = 4

# Ensure the registry path exists
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Bluetooth Support Service has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable the Bluetooth Support Service. $_" -ForegroundColor Red
    }
} else {
    Write-Host "ERROR: Registry path for Bluetooth Support Service does not exist." -ForegroundColor Red
}
