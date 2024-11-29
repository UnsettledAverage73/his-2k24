# Remedi.ps1
# Description: Disables the Microsoft FTP Service (FTPSVC) by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\FTPSVC"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Microsoft FTP Service (FTPSVC) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Microsoft FTP Service (FTPSVC). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Microsoft FTP Service (FTPSVC) is not installed. No action required." -ForegroundColor Yellow
}
