# Check.ps1 - Verify if IPv6 Source Routing Protection is set to Highest Protection

$title = "CIS Control 8.5.2 (L1) - Ensure 'MSS: (DisableIPSourceRouting IPv6) IP Source Routing Protection Level' is set to 'Enabled: Highest protection, source routing is completely disabled'"
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"
$regKey = "DisableIPSourceRouting"
$expectedValue = 2  # Highest protection

Write-Host "Checking compliance for: $title"

try {
    # Check if the registry key exists
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey
    if ($currentValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (IPv6 source routing is completely disabled)."
    } else {
        Write-Host "$title - Status: Non-Compliant (Current value: $currentValue)."
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not set)."
}

