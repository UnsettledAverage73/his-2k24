# Remedi.ps1
# Description: Disables the Simple TCP/IP Services (simptcp) by setting the registry value to 4 or uninstalls the feature if installed.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\simptcp"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Disable the service by setting the registry value
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Simple TCP/IP Services (simptcp) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Simple TCP/IP Services (simptcp). $_" -ForegroundColor Red
    }
} else {
    # Uninstall the feature if it exists
    try {
        Write-Host "INFO: Attempting to uninstall Simple TCP/IP Services feature..." -ForegroundColor Yellow
        Uninstall-WindowsFeature -Name "Simple-TCPIP"
        Write-Host "SUCCESS: Simple TCP/IP Services feature has been uninstalled." -ForegroundColor Green
    } catch {
        Write-Host "INFO: Simple TCP/IP Services feature is not installed. No action required." -ForegroundColor Yellow
    }
}
