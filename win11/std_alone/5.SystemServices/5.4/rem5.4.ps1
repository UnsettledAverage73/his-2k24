# Remedi.ps1
# Description: Disables the Downloaded Maps Manager service.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\MapsBroker"
$regValue = "Start"
$disableValue = 4

# Disable the service by setting the registry value
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Downloaded Maps Manager service has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable the Downloaded Maps Manager service. $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Downloaded Maps Manager service registry path does not exist. It may already be removed." -ForegroundColor Yellow
}
