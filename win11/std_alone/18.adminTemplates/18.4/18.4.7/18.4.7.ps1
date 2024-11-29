# Check.ps1 - Verify if 'NetBT NodeType configuration' is set to 'Enabled: P-node (recommended)'

$title = "CIS Control 18.4.7 (L1) - Ensure 'NetBT NodeType configuration' is set to 'Enabled: P-node (recommended)'"
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters"
$regKey = "NodeType"
$expectedValue = 2  # P-node (point-to-point)

Write-Host "Checking compliance for: $title"

try {
    # Check if the registry key exists
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey
    if ($currentValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (NodeType is set to P-node)."
    } else {
        Write-Host "$title - Status: Non-Compliant (Current NodeType value: $currentValue)."
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (NodeType registry key not found or not set)."
}

