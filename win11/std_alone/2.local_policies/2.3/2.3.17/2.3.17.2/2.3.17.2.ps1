# Check.ps1 - Verify 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode' is set to 'Prompt for consent on the secure desktop' or higher

$title = "CIS Control 2.3.17.2 - Ensure 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode' is set to 'Prompt for consent on the secure desktop' or higher"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "ConsentPromptBehaviorAdmin"
$expectedValue = 1  # 1 = Prompt for consent on the secure desktop, 2 = Prompt for credentials on the secure desktop

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value (1 or 2)
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (Prompt for consent/credentials on the secure desktop)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Current value is $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

