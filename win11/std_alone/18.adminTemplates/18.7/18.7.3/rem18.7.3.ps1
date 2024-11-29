# remedi.ps1
# Script to set 'Configure RPC connection settings: Protocol to use for outgoing RPC connections' to 'Enabled: RPC over TCP'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC"
$RegKey = "RpcUseNamedPipeProtocol"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 0 (RPC over TCP)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 0 -Type DWord
Write-Output "'Configure RPC connection settings' is now set to 'Enabled: RPC over TCP'."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0) {
    Write-Output "Verification successful: 'Configure RPC connection settings' is set to 'Enabled: RPC over TCP'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 0."
}
