# Check.ps1
# Description: Verifies if 'Windows Firewall: Domain: Logging: Log successful connections' is set to 'Yes'.

# Define registry path and expected value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging"
$regValue = "LogSuccessfulConnections"
$expectedValue = 1

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: 'Windows Firewall: Domain: Logging: Log successful connections' is set to Yes." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Windows Firewall: Domain: Logging: Log successful connections' is set to No or misconfigured." -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for 'Windows Firewall: Domain: Logging: Log successful connections' does not exist." -ForegroundColor Red
}
