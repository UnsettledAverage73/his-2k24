# Check.ps1 - Verify 'Network security: Allow Local System to use computer identity for NTLM' is set to 'Enabled'

$title = "CIS Control 2.3.11.1 - Ensure 'Network security: Allow Local System to use computer identity for NTLM' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "UseMachineId"
$expectedValue = 1

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value is set to 1 (Enabled)
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (UseMachineId is set to 1, as expected)"
    } else {
        Write-Host "$title - Status: Non-Compliant (UseMachineId is set to $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

