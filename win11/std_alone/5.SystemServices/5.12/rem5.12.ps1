# Remedi.ps1
# Description: Disables the OpenSSH SSH Server (sshd) by setting the registry value to 4.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\sshd"
$regValue = "Start"
$disableValue = 4

# Check if the service is installed
if (Test-Path -Path $regPath) {
    try {
        # Set the registry value to disable the service
        Set-ItemProperty -Path $regPath -Name $regValue -Value $disableValue
        Write-Host "SUCCESS: OpenSSH SSH Server (sshd) has been disabled (`Start` = 4)." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to disable OpenSSH SSH Server (sshd). $_" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: OpenSSH SSH Server (sshd) is not installed. No action required." -ForegroundColor Yellow
}
