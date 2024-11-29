# Check.ps1 - Verify 'Network security: Do not store LAN Manager hash value on next password change' is set to 'Enabled'

$title = "CIS Control 2.3.11.5 - Ensure 'Network security: Do not store LAN Manager hash value on next password change' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "NoLMHash"
$expectedValue = 1

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (NoLMHash is set to 1, as expected)"
    } else {
        Write-Host "$title - Status: Non-Compliant (NoLMHash is set to $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

