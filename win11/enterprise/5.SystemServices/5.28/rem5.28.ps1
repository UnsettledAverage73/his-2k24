# Remedi.ps1
# Description: Disables the SNMP Service (SNMP) by setting the registry value to 4 or uninstalls the feature if installed.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Disable the service by setting the registry value
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: SNMP Service (SNMP) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable SNMP Service (SNMP). $_" -ForegroundColor Red
    }
} else {
    # Uninstall the feature if it exists
    try {
        Write-Host "INFO: Attempting to uninstall SNMP Service feature..." -ForegroundColor Yellow
        Uninstall-WindowsFeature -Name "SNMP-Service"
        Write-Host "SUCCESS: SNMP Service feature has been uninstalled." -ForegroundColor Green
    } catch {
        Write-Host "INFO: SNMP Service feature is not installed. No action required." -ForegroundColor Yellow
    }
}
