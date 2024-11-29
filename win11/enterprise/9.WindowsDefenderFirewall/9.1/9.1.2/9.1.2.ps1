# Check.ps1
# Description: Verifies that 'Windows Firewall: Domain: Inbound Connections' is set to Block (default).

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
$regValue = "DefaultInboundAction"
$expectedValue = 1  # 1 = Block (default)

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: 'Windows Firewall: Domain: Inbound Connections' is set to Block (default)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Windows Firewall: Domain: Inbound Connections' is not set to Block. Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for 'Windows Firewall: Domain: Inbound Connections' does not exist." -ForegroundColor Red
}
