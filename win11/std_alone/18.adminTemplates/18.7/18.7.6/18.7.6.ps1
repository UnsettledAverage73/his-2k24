# check.ps1
# Script to check if 'Configure RPC listener settings: Authentication protocol to use for incoming RPC connections' is set to 'Enabled: Negotiate or higher'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC"
$RegKey = "ForceKerberosForRpc"

# Check if the registry key exists and the value is set to 0 or 1 (Enabled: Negotiate or higher)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0 -or $CurrentValue -eq 1) {
    Write-Output "Pass: 'Configure RPC listener settings' is set to 'Enabled: Negotiate or higher'."
} else {
    Write-Output "Fail: 'Configure RPC listener settings' is not set correctly. Current value: $CurrentValue (Expected: 0 or 1)."
}
