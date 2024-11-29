# Check.ps1
# Description: Verifies if 'Windows Firewall: Public: Inbound connections' is set to Block (default).

# Define registry path and expected value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile"
$regValue = "DefaultInboundAction"
$expectedValue = 1  # 1 means Block (default)

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: 'Windows Firewall: Public: Inbound connections' is set to Block (default)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Windows Firewall: Public: Inbound connections' is not set to Block (default). Current value: $currentValue." -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for 'Windows Firewall: Public: Inbound connections' does not exist." -ForegroundColor Red
}
