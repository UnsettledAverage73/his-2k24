# check.ps1
# Script to check if 'Allow Print Spooler to accept client connections' is set to 'Disabled'

# Registry path and key
$RegPath = "HKLM:\Software\Policies\Microsoft\Windows NT\Printers"
$RegKey = "RegisterSpoolerRemoteRpcEndPoint"

# Check if the registry key exists and the value is set to 2 (Disabled)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 2) {
    Write-Output "Pass: 'Allow Print Spooler to accept client connections' is set to 'Disabled'."
} else {
    Write-Output "Fail: 'Allow Print Spooler to accept client connections' is not set correctly. Current value: $CurrentValue"
}
