# Check.ps1 - Verify 'Allow Online Tips' is set to 'Disabled'

$title = "CIS Control 18.1.3 (L2) - Ensure 'Allow Online Tips' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$regKey = "AllowOnlineTips"
$expectedValue = 0  # 0 = Disabled

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value (0)
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (Disabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Current value is $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

