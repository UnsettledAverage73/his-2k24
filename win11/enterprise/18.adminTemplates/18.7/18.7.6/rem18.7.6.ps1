# remedi.ps1
# Script to set 'Configure RPC listener settings: Authentication protocol to use for incoming RPC connections' to 'Enabled: Negotiate or higher'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC"
$RegKey = "ForceKerberosForRpc"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 0 (Negotiate) or 1 (Kerberos for stricter enforcement)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 0 -Type DWord
Write-Output "'Configure RPC listener settings: Authentication protocol to use for incoming RPC connections' is now set to 'Enabled: Negotiate or higher'."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0 -or $CurrentValue -eq 1) {
    Write-Output "Verification successful: 'Configure RPC listener settings' is set to 'Enabled: Negotiate or higher'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 0 or 1."
}
