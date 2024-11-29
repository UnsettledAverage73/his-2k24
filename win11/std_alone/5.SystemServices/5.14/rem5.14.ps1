# Remedi.ps1
# Description: Disables the Peer Networking Grouping (p2psvc) by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\p2psvc"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Peer Networking Grouping (p2psvc) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Peer Networking Grouping (p2psvc). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Peer Networking Grouping (p2psvc) is not installed. No action required." -ForegroundColor Yellow
}
