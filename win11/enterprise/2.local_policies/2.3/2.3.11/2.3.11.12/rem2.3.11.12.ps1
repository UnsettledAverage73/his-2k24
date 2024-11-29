# Remedi.ps1 - Configure 'Network security: Restrict NTLM: Outgoing NTLM traffic to remote servers' to 'Audit all' or higher

$title = "CIS Control 2.3.11.12 - Ensure 'Network security: Restrict NTLM: Outgoing NTLM traffic to remote servers' is set to 'Audit all' or higher"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$regKey = "RestrictSendingNTLMTraffic"
$expectedValue = 2

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'Audit all' (value = 2)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. Outgoing NTLM traffic is now audited."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

