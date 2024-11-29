# Remedi.ps1 - Configure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) clients' to 'Require NTLMv2 session security, Require 128-bit encryption'

$title = "CIS Control 2.3.11.9 - Ensure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) clients' is set to 'Require NTLMv2 session security, Require 128-bit encryption'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$regKey = "NTLMMinClientSec"
$expectedValue = 537395200

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the recommended configuration (Require NTLMv2 session security, Require 128-bit encryption)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. Minimum session security set to 'Require NTLMv2 session security, Require 128-bit encryption'."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

