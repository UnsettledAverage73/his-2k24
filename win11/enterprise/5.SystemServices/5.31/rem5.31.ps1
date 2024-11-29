# Remedi.ps1
# Description: Disables the UPnP Device Host (upnphost) service by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\upnphost"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Disable the service by setting the registry value
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: UPnP Device Host (upnphost) service has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable UPnP Device Host (upnphost) service. $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: UPnP Device Host (upnphost) service is not installed. No action required." -ForegroundColor Yellow
}
