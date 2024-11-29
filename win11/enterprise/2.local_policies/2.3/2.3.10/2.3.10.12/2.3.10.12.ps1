# Check.ps1 - Verify 'Network access: Sharing and security model for local accounts' is set to 'Classic - local users authenticate as themselves'

$title = "CIS Control 2.3.10.12 - Ensure 'Network access: Sharing and security model for local accounts' is set to 'Classic - local users authenticate as themselves'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "ForceGuest"
$expectedValue = 0

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value is set to 0 (Classic model)
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (ForceGuest is set to 0, as expected)"
    } else {
        Write-Host "$title - Status: Non-Compliant (ForceGuest is set to $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

