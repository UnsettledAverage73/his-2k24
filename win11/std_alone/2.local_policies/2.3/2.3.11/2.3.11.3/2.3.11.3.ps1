# Check.ps1 - Verify 'Network Security: Allow PKU2U authentication requests to this computer to use online identities' is set to 'Disabled'

$title = "CIS Control 2.3.11.3 - Ensure 'Network Security: Allow PKU2U authentication requests to this computer to use online identities' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\pku2u"
$regKey = "AllowOnlineID"
$expectedValue = 0

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value is set to 0 (Disabled)
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (AllowOnlineID is set to 0, as expected)"
    } else {
        Write-Host "$title - Status: Non-Compliant (AllowOnlineID is set to $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

