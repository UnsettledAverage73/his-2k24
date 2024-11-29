# Check.ps1 - Verify 'Network security: LDAP client signing requirements' is set to 'Negotiate signing' or higher

$title = "CIS Control 2.3.11.8 - Ensure 'Network security: LDAP client signing requirements' is set to 'Negotiate signing' or higher"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LDAP"
$regKey = "LDAPClientIntegrity"
$expectedValue = 1

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (Negotiate signing)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Current value is $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

