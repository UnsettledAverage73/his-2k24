# Check.ps1 - Verify 'Enable Certificate Padding' is set to 'Enabled'

$title = "CIS Control 18.4.5 (L1) - Ensure 'Enable Certificate Padding' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Cryptography\Wintrust\Config"
$regKey = "EnableCertPaddingCheck"
$expectedValue = 1  # 1 = Enabled

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value (1)
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant ('Enable Certificate Padding' is Enabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Current value is $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not set)"
}

