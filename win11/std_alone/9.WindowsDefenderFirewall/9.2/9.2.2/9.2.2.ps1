# Check.ps1
# Description: Verifies if 'Windows Firewall: Private: Inbound connections' is set to 'Block (default)'.

# Define registry path and expected value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile"
$regValue = "DefaultInboundAction"
$expectedValue = 1 # 1 = Block

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: 'Windows Firewall: Private: Inbound connections' is set to 'Block (default)'." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Windows Firewall: Private: Inbound connections' is not set to 'Block (default)' or misconfigured." -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for 'Windows Firewall: Private: Inbound connections' does not exist." -ForegroundColor Red
}
