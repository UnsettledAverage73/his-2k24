# Check.ps1 - Verify 'Enable Structured Exception Handling Overwrite Protection (SEHOP)' is set to 'Enabled'

$title = "CIS Control 18.4.6 (L1) - Ensure 'Enable Structured Exception Handling Overwrite Protection (SEHOP)' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel"
$regKey = "DisableExceptionChainValidation"
$expectedValue = 0  # 0 = Enabled

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value (0)
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant ('Enable SEHOP' is Enabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Current value is $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not set)"
}

