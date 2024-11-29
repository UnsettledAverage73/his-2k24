# check.ps1
# Script to check if 'Configure RPC listener settings: Protocols to allow for incoming RPC connections' is set to 'Enabled: RPC over TCP'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC"
$RegKey = "RpcProtocols"

# Check if the registry key exists and the value is set to 5 (Enabled: RPC over TCP)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 5) {
    Write-Output "Pass: 'Configure RPC listener settings' is set to 'Enabled: RPC over TCP'."
} else {
    Write-Output "Fail: 'Configure RPC listener settings' is not set correctly. Current value: $CurrentValue (Expected: 5)."
}
