# Remedi.ps1
# Description: Disables the Geolocation Service (lfsvc).

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc"
$regValue = "Start"
$disableValue = 4

# Disable the service by setting the registry value
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Geolocation Service (lfsvc) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable the Geolocation Service (lfsvc). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Geolocation Service (lfsvc) registry path does not exist. It may already be removed." -ForegroundColor Yellow
}
