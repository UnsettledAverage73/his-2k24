# remedi.ps1
# Script to set 'Configure RPC listener settings: Protocols to allow for incoming RPC connections' to 'Enabled: RPC over TCP'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC"
$RegKey = "RpcProtocols"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 5 (Enabled: RPC over TCP)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 5 -Type DWord
Write-Output "'Configure RPC listener settings: Protocols to allow for incoming RPC connections' is now set to 'Enabled: RPC over TCP'."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 5) {
    Write-Output "Verification successful: 'Configure RPC listener settings' is set to 'Enabled: RPC over TCP'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 5."
}
