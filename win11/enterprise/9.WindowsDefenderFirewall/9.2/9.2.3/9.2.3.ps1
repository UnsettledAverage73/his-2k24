# Check.ps1
# Description: Verifies if 'Windows Firewall: Private: Settings: Display a notification' is set to 'No'.

# Define registry path and expected value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile"
$regValue = "DisableNotifications"
$expectedValue = 1 # 1 = No

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: 'Windows Firewall: Private: Settings: Display a notification' is set to 'No'." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Windows Firewall: Private: Settings: Display a notification' is not set to 'No' or misconfigured." -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for 'Windows Firewall: Private: Settings: Display a notification' does not exist." -ForegroundColor Red
}
