# Remedi.ps1
# Description: Disables the World Wide Web Publishing Service (W3SVC) by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\W3SVC"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Disable the service by setting the registry value
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: World Wide Web Publishing Service (W3SVC) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable World Wide Web Publishing Service (W3SVC). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: World Wide Web Publishing Service (W3SVC) is not installed." -ForegroundColor Yellow
}
