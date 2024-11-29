# Title: CIS Control 18.5.6 (L2) - Ensure 'MSS: (KeepAliveTime)' Is Set to 'Enabled: 300,000 or 5 Minutes'

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$regValueName = "KeepAliveTime"
$expectedValue = 300000

Write-Host "Checking compliance for: CIS Control 18.5.6 (L2) - KeepAliveTime"

# Check if the registry key exists
if (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Status: Compliant (KeepAliveTime is set to 300,000 or 5 minutes)." -ForegroundColor Green
    } else {
        Write-Host "Status: Non-Compliant (Current value: $currentValue)." -ForegroundColor Red
    }
} else {
    Write-Host "Status: Non-Compliant (KeepAliveTime registry key not found)." -ForegroundColor Red
}

