# Remedi.ps1
# Description: Disables the Server (LanmanServer) service by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Server (LanmanServer) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Server (LanmanServer). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Server (LanmanServer) service is not installed. No action required." -ForegroundColor Yellow
}
