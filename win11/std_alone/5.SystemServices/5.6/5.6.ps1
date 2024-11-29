# Check.ps1
# Description: Verifies if IIS Admin Service (IISADMIN) is disabled or not installed.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\IISADMIN"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: IIS Admin Service (IISADMIN) is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: IIS Admin Service (IISADMIN) is not set to Disabled (`Start` = 4). Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "PASS: IIS Admin Service (IISADMIN) is not installed." -ForegroundColor Green
}
