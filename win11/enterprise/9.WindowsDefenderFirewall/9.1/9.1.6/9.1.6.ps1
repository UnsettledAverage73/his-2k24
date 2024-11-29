# Check.ps1
# Description: Verifies if 'Windows Firewall: Domain: Logging: Size limit (KB)' is set to '16,384 KB or greater'.

# Define registry path and expected value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging"
$regValue = "LogFileSize"
$expectedValue = 16384

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -ge $expectedValue) {
        Write-Host "PASS: 'Windows Firewall: Domain: Logging: Size limit (KB)' is set to $currentValue, which meets or exceeds the recommended value of $expectedValue." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Windows Firewall: Domain: Logging: Size limit (KB)' is set to $currentValue, which is less than the recommended value of $expectedValue." -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for 'Windows Firewall: Domain: Logging: Size limit (KB)' does not exist." -ForegroundColor Red
}
