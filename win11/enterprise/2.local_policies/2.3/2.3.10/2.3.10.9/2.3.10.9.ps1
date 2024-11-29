# Check.ps1 - Verify 'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'

$title = "CIS Control 2.3.10.9 - Ensure 'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$regKey = "RestrictNullSessAccess"
$expectedValue = 1

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Compare the value
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (Value: $regValue)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Expected: $expectedValue, Found: $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not configured)"
}

