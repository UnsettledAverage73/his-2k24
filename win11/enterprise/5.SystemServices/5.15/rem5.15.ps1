# Remedi.ps1
# Description: Disables the Peer Networking Identity Manager (p2pimsvc) by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\p2pimsvc"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Peer Networking Identity Manager (p2pimsvc) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Peer Networking Identity Manager (p2pimsvc). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Peer Networking Identity Manager (p2pimsvc) is not installed. No action required." -ForegroundColor Yellow
}
