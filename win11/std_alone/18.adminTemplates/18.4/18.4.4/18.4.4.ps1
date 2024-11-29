# Check.ps1 - Verify 'Configure SMB v1 server' is set to 'Disabled'

$title = "CIS Control 18.4.4 (L1) - Ensure 'Configure SMB v1 server' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$regKey = "SMB1"
$expectedValue = 0  # 0 = Disabled

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value (0)
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (SMBv1 is Disabled)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Current value is $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found or not set)"
}

