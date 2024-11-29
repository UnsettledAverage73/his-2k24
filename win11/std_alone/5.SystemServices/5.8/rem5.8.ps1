# Remedi.ps1
# Description: Disables the Infrared Monitor Service (irmon) or ensures it is not installed.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\irmon"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Infrared Monitor Service (irmon) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable the Infrared Monitor Service (irmon). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Infrared Monitor Service (irmon) is not installed. No action required." -ForegroundColor Yellow
}
