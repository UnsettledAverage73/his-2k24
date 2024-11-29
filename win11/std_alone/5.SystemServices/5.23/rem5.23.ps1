# Remedi.ps1
# Description: Disables the Remote Procedure Call (RPC) Locator (RpcLocator) service by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\RpcLocator"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Remote Procedure Call (RPC) Locator (RpcLocator) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Remote Procedure Call (RPC) Locator (RpcLocator). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Remote Procedure Call (RPC) Locator (RpcLocator) is not installed. No action required." -ForegroundColor Yellow
}
