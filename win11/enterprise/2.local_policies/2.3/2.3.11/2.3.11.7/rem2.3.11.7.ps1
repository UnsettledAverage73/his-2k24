# Remedi.ps1 - Configure 'Network security: LAN Manager authentication level' to 'Send NTLMv2 response only. Refuse LM & NTLM'

$title = "CIS Control 2.3.11.7 - Ensure 'Network security: LAN Manager authentication level' is set to 'Send NTLMv2 response only. Refuse LM & NTLM'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "LmCompatibilityLevel"
$expectedValue = 5

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the recommended configuration (Send NTLMv2 response only. Refuse LM & NTLM)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. NTLMv2 response only, LM & NTLM refused."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

