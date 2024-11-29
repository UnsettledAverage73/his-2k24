# Check.ps1
# Description: Verifies if 'Windows Firewall: Private: Logging: Log successful connections' is set to Yes.

# Define registry path and expected value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging"
$regValue = "LogSuccessfulConnections"
$expectedValue = 1  # 1 means Yes

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: 'Windows Firewall: Private: Logging: Log successful connections' is set to Yes." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Windows Firewall: Private: Logging: Log successful connections' is not set to Yes. Current value: $currentValue." -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for 'Windows Firewall: Private: Logging: Log successful connections' does not exist." -ForegroundColor Red
}
