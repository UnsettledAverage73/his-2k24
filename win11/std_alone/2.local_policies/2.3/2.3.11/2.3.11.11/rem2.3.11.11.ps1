# Remedi.ps1 - Configure 'Network security: Restrict NTLM: Audit Incoming NTLM Traffic' to 'Enable auditing for all accounts'

$title = "CIS Control 2.3.11.11 - Ensure 'Network security: Restrict NTLM: Audit Incoming NTLM Traffic' is set to 'Enable auditing for all accounts'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$regKey = "AuditReceivingNTLMTraffic"
$expectedValue = 2

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to enable auditing for all accounts
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. Auditing for all accounts enabled."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

