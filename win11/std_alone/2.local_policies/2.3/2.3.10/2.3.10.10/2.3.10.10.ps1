# Check.ps1 - Verify 'Network access: Restrict clients allowed to make remote calls to SAM' is set to 'Administrators: Remote Access: Allow'

$title = "CIS Control 2.3.10.10 - Ensure 'Network access: Restrict clients allowed to make remote calls to SAM' is set to 'Administrators: Remote Access: Allow'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "restrictremotesam"
$expectedValue = "O:BAG:BAD:(A;;RC;;;BA)"

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

