# Remedi.ps1
# Description: Disables the Windows Media Player Network Sharing Service (WMPNetworkSvc) by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\WMPNetworkSvc"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Disable the service by setting the registry value
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Windows Media Player Network Sharing Service (WMPNetworkSvc) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Windows Media Player Network Sharing Service (WMPNetworkSvc). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Windows Media Player Network Sharing Service (WMPNetworkSvc) registry key does not exist. The service may not be installed." -ForegroundColor Yellow
}
