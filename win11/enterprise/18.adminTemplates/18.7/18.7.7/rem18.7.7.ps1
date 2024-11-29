# remedi.ps1
# Script to set 'Configure RPC over TCP port' to 'Enabled: 0'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC"
$RegKey = "RpcTcpPort"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 0
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 0 -Type DWord
Write-Output "'Configure RPC over TCP port' is now set to 'Enabled: 0'."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0) {
    Write-Output "Verification successful: 'Configure RPC over TCP port' is set to 'Enabled: 0'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 0."
}
