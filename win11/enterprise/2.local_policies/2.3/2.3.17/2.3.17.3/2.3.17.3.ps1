# Check.ps1 - Verify 'User Account Control: Behavior of the elevation prompt for standard users' is set to 'Automatically deny elevation requests'

$title = "CIS Control 2.3.17.3 - Ensure 'User Account Control: Behavior of the elevation prompt for standard users' is set to 'Automatically deny elevation requests'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "ConsentPromptBehaviorUser"
$expectedValue = 0  # 0 = Automatically deny elevation requests

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value (0)
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (Automatically deny elevation requests)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Current value is $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

