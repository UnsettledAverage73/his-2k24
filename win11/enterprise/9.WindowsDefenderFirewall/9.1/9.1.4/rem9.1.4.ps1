# Remedi.ps1
# Description: Sets 'Windows Firewall: Domain: Logging: Name' to '%SystemRoot%\System32\logfiles\firewall\domainfw.log'.

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging"
$regValue = "LogFilePath"
$newValue = "%SystemRoot%\System32\logfiles\firewall\domainfw.log"

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

# Set the registry value to the specified log file path
try {
    Set-ItemProperty -Path $regPath -Name $regValue -Value $newValue
    Write-Host "SUCCESS: 'Windows Firewall: Domain: Logging: Name' has been set to $newValue." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure 'Windows Firewall: Domain: Logging: Name'. $_" -ForegroundColor Red
}
