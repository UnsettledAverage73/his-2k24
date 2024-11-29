# Remedi.ps1
# Description: Disables the Remote Registry (RemoteRegistry) service by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\RemoteRegistry"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Remote Registry (RemoteRegistry) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Remote Registry (RemoteRegistry). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Remote Registry (RemoteRegistry) service is not installed. No action required." -ForegroundColor Yellow
}
