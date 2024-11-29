# Remedi.ps1
# Description: Disables the Xbox Live Auth Manager (XblAuthManager) service by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\XblAuthManager"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Disable the service by setting the registry value
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Xbox Live Auth Manager (XblAuthManager) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Xbox Live Auth Manager (XblAuthManager). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Xbox Live Auth Manager (XblAuthManager) is not installed." -ForegroundColor Yellow
}
