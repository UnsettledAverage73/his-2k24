# Title: CIS Control 18.5.8 (L2) - Ensure 'MSS: (PerformRouterDiscovery)' Is Set to 'Disabled'

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$regValueName = "PerformRouterDiscovery"
$expectedValue = 0

Write-Host "Checking compliance for: CIS Control 18.5.8 (L2) - PerformRouterDiscovery"

# Check if the registry key exists
if (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Status: Compliant (PerformRouterDiscovery is set to Disabled)." -ForegroundColor Green
    } else {
        Write-Host "Status: Non-Compliant (Current value: $currentValue)." -ForegroundColor Red
    }
} else {
    Write-Host "Status: Non-Compliant (PerformRouterDiscovery registry key not found)." -ForegroundColor Red
}

