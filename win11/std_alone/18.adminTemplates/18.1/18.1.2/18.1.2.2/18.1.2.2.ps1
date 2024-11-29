# Check.ps1 - Verify 'Allow users to enable online speech recognition services' is set to 'Disabled'

$title = "CIS Control 18.1.2.2 - Ensure 'Allow users to enable online speech recognition services' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization"
$regKey = "AllowInputPersonalization"
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

