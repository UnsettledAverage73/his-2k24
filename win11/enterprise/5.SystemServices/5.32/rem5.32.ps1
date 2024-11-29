# Remedi.ps1
# Description: Disables the Web Management Service (WMSvc) by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\WMSvc"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Disable the service by setting the registry value
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Web Management Service (WMSvc) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Web Management Service (WMSvc). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Web Management Service (WMSvc) is not installed. No action required." -ForegroundColor Yellow
}
