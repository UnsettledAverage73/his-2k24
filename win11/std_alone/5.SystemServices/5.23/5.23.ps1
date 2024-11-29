# Check.ps1
# Description: Verifies if the Remote Procedure Call (RPC) Locator (RpcLocator) service is Disabled.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\RpcLocator"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: Remote Procedure Call (RPC) Locator (RpcLocator) is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Remote Procedure Call (RPC) Locator (RpcLocator) is not set to Disabled (`Start` = 4). Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "PASS: Remote Procedure Call (RPC) Locator (RpcLocator) is not installed." -ForegroundColor Green
}
