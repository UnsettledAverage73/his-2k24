# Remedi.ps1
# Description: Disables the IIS Admin Service (IISADMIN) or ensures it is not installed.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\IISADMIN"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: IIS Admin Service (IISADMIN) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable the IIS Admin Service (IISADMIN). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: IIS Admin Service (IISADMIN) is not installed. No action required." -ForegroundColor Yellow
}
