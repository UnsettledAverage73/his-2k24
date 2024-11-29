# check.ps1
# Script to check if 'Configure RPC over TCP port' is set to 'Enabled: 0'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC"
$RegKey = "RpcTcpPort"

# Check if the registry key exists and the value is set to 0
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0) {
    Write-Output "Pass: 'Configure RPC over TCP port' is set to 'Enabled: 0'."
} else {
    Write-Output "Fail: 'Configure RPC over TCP port' is not set correctly. Current value: $CurrentValue (Expected: 0)."
}
