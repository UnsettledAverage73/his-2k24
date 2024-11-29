# Check.ps1
# Description: Verifies if the Remote Desktop Services UserMode Port Redirector (UmRdpService) service is Disabled.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\UmRdpService"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: Remote Desktop Services UserMode Port Redirector (UmRdpService) is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Remote Desktop Services UserMode Port Redirector (UmRdpService) is not set to Disabled (`Start` = 4). Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "PASS: Remote Desktop Services UserMode Port Redirector (UmRdpService) is not installed." -ForegroundColor Green
}
