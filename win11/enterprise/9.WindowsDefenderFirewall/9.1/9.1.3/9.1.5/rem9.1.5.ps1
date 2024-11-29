# Remedi.ps1
# Description: Sets 'Windows Firewall: Domain: Logging: Size limit (KB)' to '16,384 KB or greater'.

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging"
$regValue = "LogFileSize"
$newValue = 16384

# Ensure the registry path exists
if (-not (Test-Path -Path $regPath)) {
    try {
        New-Item -Path $regPath -Force | Out-Null
        Write-Host "INFO: Created missing registry path: $regPath." -ForegroundColor Yellow
    } catch {
        Write-Host "ERROR: Failed to create registry path: $regPath. $_" -ForegroundColor Red
        exit
    }
}

# Set the registry value to the specified size
try {
    Set-ItemProperty -Path $regPath -Name $regValue -Value $newValue
    Write-Host "SUCCESS: 'Windows Firewall: Domain: Logging: Size limit (KB)' has been set to $newValue KB." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure 'Windows Firewall: Domain: Logging: Size limit (KB)'. $_" -ForegroundColor Red
}
