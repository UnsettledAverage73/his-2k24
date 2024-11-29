# Remedi.ps1
# Description: Disables the Problem Reports and Solutions Control Panel Support (wercplsupport) service by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\wercplsupport"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Problem Reports and Solutions Control Panel Support service has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Problem Reports and Solutions Control Panel Support service. $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Problem Reports and Solutions Control Panel Support service is not installed. No action required." -ForegroundColor Yellow
}
