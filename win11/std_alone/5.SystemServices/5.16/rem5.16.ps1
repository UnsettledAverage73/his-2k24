# Remedi.ps1
# Description: Disables the PNRP Machine Name Publication Service (PNRPAutoReg) by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\PNRPAutoReg"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: PNRP Machine Name Publication Service (PNRPAutoReg) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable PNRP Machine Name Publication Service (PNRPAutoReg). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: PNRP Machine Name Publication Service (PNRPAutoReg) is not installed. No action required." -ForegroundColor Yellow
}
