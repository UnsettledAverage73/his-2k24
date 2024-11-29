# Check.ps1
# Description: Verifies if the Windows Firewall: Domain: Firewall state is set to On (recommended).

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile"
$regValue = "EnableFirewall"
$expectedValue = 1

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: Windows Firewall: Domain: Firewall state is set to On (recommended) (`EnableFirewall` = 1)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Windows Firewall: Domain: Firewall state is not set to On. Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path for Windows Firewall: Domain: Firewall state does not exist." -ForegroundColor Red
}
