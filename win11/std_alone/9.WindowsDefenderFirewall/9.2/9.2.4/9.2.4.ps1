# Check.ps1
# Description: Verifies if 'Windows Firewall: Private: Logging: Name' is set to the correct log file path.

# Define registry path and expected value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging"
$regValue = "LogFilePath"
$expectedValue = "%SystemRoot%\System32\logfiles\firewall\privatefw.log"

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: 'Windows Firewall: Private: Logging: Name' is set correctly to '$expectedValue'." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Windows Firewall: Private: Logging: Name' is not set correctly. Current value: '$currentValue'." -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for 'Windows Firewall: Private: Logging: Name' does not exist." -ForegroundColor Red
}
