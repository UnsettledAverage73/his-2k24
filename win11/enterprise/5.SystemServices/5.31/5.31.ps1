# Check.ps1
# Description: Verifies if the UPnP Device Host (upnphost) service is Disabled.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\upnphost"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: UPnP Device Host (upnphost) service is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: UPnP Device Host (upnphost) service is not set to Disabled. Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "INFO: UPnP Device Host (upnphost) service registry key does not exist. Service might not be installed." -ForegroundColor Yellow
}
