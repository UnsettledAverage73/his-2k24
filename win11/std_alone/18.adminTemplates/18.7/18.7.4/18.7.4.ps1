# check.ps1
# Script to check if 'Configure RPC connection settings: Use authentication for outgoing RPC connections' is set to 'Enabled: Default'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC"
$RegKey = "RpcAuthentication"

# Check if the registry key exists and the value is set to 0 (Enabled: Default)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0) {
    Write-Output "Pass: 'Configure RPC connection settings: Use authentication for outgoing RPC connections' is set to 'Enabled: Default'."
} else {
    Write-Output "Fail: 'Configure RPC connection settings' is not set correctly. Current value: $CurrentValue (Expected: 0)."
}
