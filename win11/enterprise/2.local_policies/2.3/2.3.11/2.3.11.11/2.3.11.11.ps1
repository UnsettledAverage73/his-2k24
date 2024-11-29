# Check.ps1 - Verify 'Network security: Restrict NTLM: Audit Incoming NTLM Traffic' is set to 'Enable auditing for all accounts'

$title = "CIS Control 2.3.11.11 - Ensure 'Network security: Restrict NTLM: Audit Incoming NTLM Traffic' is set to 'Enable auditing for all accounts'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$regKey = "AuditReceivingNTLMTraffic"
$expectedValue = 2

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (Auditing for all accounts)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Current value is $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

