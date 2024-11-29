# Check.ps1 - Verify 'Network security: Allow LocalSystem NULL session fallback' is set to 'Disabled'

$title = "CIS Control 2.3.11.2 - Ensure 'Network security: Allow LocalSystem NULL session fallback' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$regKey = "AllowNullSessionFallback"
$expectedValue = 0

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value is set to 0 (Disabled)
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (AllowNullSessionFallback is set to 0, as expected)"
    } else {
        Write-Host "$title - Status: Non-Compliant (AllowNullSessionFallback is set to $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

