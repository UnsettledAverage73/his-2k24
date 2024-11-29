# Check.ps1
# Description: Verifies if the Windows Media Player Network Sharing Service (WMPNetworkSvc) is Disabled.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\WMPNetworkSvc"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: Windows Media Player Network Sharing Service (WMPNetworkSvc) is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Windows Media Player Network Sharing Service (WMPNetworkSvc) is not set to Disabled. Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: Windows Media Player Network Sharing Service (WMPNetworkSvc) registry key does not exist. The service may not be installed." -ForegroundColor Yellow
}
