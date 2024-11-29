# Remedi.ps1
# Description: Disables the Microsoft iSCSI Initiator Service (MSiSCSI) by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\MSiSCSI"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: Microsoft iSCSI Initiator Service (MSiSCSI) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable Microsoft iSCSI Initiator Service (MSiSCSI). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Microsoft iSCSI Initiator Service (MSiSCSI) is not installed. No action required." -ForegroundColor Yellow
}
