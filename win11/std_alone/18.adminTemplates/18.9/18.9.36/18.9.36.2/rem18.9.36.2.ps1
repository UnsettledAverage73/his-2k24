# remedi.ps1
# Script to set "Restrict Unauthenticated RPC Clients" to Enabled: Authenticated

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Rpc"
$regValue = "RestrictRemoteClients"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to 1 (Enabled: Authenticated)
Set-ItemProperty -Path $regPath -Name $regValue -Value 1 -Type DWord

# Verify the setting
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 1) {
    Write-Output "'Restrict Unauthenticated RPC Clients' has been successfully set to Enabled: Authenticated."
} else {
    Write-Output "ERROR: Failed to set 'Restrict Unauthenticated RPC Clients' to Enabled: Authenticated."
}
