# Check.ps1
# Description: Verifies if 'Windows Firewall: Private: Logging: Size limit (KB)' is set to 16,384 KB or greater.

# Define registry path and expected value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging"
$regValue = "LogFileSize"
$expectedMinimum = 16384  # Minimum size in KB

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -ge $expectedMinimum) {
        Write-Host "PASS: 'Windows Firewall: Private: Logging: Size limit (KB)' is set correctly to $currentValue KB." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Windows Firewall: Private: Logging: Size limit (KB)' is set to $currentValue KB, which is less than the recommended $expectedMinimum KB." -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for 'Windows Firewall: Private: Logging: Size limit (KB)' does not exist." -ForegroundColor Red
}
