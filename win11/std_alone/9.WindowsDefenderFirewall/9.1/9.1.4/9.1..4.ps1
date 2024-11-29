# Check.ps1
# Description: Verifies if 'Windows Firewall: Domain: Logging: Name' is set to '%SystemRoot%\System32\logfiles\firewall\domainfw.log'.

# Define registry path and expected value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging"
$regValue = "LogFilePath"
$expectedValue = "%SystemRoot%\System32\logfiles\firewall\domainfw.log"

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: 'Windows Firewall: Domain: Logging: Name' is correctly set to $expectedValue." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Windows Firewall: Domain: Logging: Name' is not set correctly. Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for 'Windows Firewall: Domain: Logging: Name' does not exist." -ForegroundColor Red
}
