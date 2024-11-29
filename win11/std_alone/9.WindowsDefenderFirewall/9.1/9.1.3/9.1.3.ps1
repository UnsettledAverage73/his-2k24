# Check.ps1
# Description: Verifies that 'Windows Firewall: Domain: Settings: Display a Notification' is set to No.

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
$regValue = "DisableNotifications"
$expectedValue = 1  # 1 = No (Notifications Disabled)

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: 'Windows Firewall: Domain: Settings: Display a Notification' is set to No (Notifications Disabled)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Windows Firewall: Domain: Settings: Display a Notification' is not set to No. Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for 'Windows Firewall: Domain: Settings: Display a Notification' does not exist." -ForegroundColor Red
}
