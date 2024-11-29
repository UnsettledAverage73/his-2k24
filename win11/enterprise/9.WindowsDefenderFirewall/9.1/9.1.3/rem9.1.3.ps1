# Remedi.ps1
# Description: Configures 'Windows Firewall: Domain: Settings: Display a Notification' to No (Notifications Disabled).

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
$regValue = "DisableNotifications"
$noNotificationsValue = 1  # 1 = No (Notifications Disabled)

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

# Set the registry value to disable notifications
try {
    Set-ItemProperty -Path $regPath -Name $regValue -Value $noNotificationsValue
    Write-Host "SUCCESS: 'Windows Firewall: Domain: Settings: Display a Notification' has been set to No (Notifications Disabled)." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure 'Windows Firewall: Domain: Settings: Display a Notification'. $_" -ForegroundColor Red
}
