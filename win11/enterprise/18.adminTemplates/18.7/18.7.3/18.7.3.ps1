# check.ps1
# Script to check if 'Configure RPC connection settings: Protocol to use for outgoing RPC connections' is set to 'Enabled: RPC over TCP'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC"
$RegKey = "RpcUseNamedPipeProtocol"

# Check if the registry key exists and the value is set to 0 (RPC over TCP)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0) {
    Write-Output "Pass: 'Configure RPC connection settings' is set to 'Enabled: RPC over TCP'."
} else {
    Write-Output "Fail: 'Configure RPC connection settings' is not set correctly. Current value: $CurrentValue (Expected: 0)."
}
