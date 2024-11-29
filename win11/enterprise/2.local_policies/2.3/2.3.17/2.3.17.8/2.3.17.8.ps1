# Check.ps1 - Verify 'User Account Control: Virtualize file and registry write failures to per-user locations' is set to 'Enabled'

$title = "CIS Control 2.3.17.8 - Ensure 'User Account Control: Virtualize file and registry write failures to per-user locations' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "EnableVirtualization"
$expectedValue = 1  # 1 = Enabled

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value (1)
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (Enabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Current value is $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

