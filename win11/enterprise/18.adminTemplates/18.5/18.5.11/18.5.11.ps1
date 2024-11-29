# Title: CIS Control 18.5.11 (L2) - Check 'TcpMaxDataRetransmissions IPv6'

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters"
$regValueName = "TcpMaxDataRetransmissions"
$expectedValue = 3

Write-Host "Checking compliance for: CIS Control 18.5.11 (L2) - TcpMaxDataRetransmissions IPv6"

# Check if the registry key exists
if (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Status: Compliant (TcpMaxDataRetransmissions is set to $currentValue)." -ForegroundColor Green
    } else {
        Write-Host "Status: Non-Compliant (Current value: $currentValue)." -ForegroundColor Red
    }
} else {
    Write-Host "Status: Non-Compliant (TcpMaxDataRetransmissions registry key not found)." -ForegroundColor Red
}

