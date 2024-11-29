# Remedi.ps1
# Description: Disables the SSDP Discovery (SSDPSRV) service by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SSDPSRV"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Disable the service by setting the registry value
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: SSDP Discovery (SSDPSRV) service has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable SSDP Discovery (SSDPSRV) service. $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: SSDP Discovery (SSDPSRV) service is not installed. No action required." -ForegroundColor Yellow
}
