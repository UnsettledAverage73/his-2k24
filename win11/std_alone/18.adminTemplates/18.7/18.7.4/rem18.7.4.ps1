# remedi.ps1
# Script to set 'Configure RPC connection settings: Use authentication for outgoing RPC connections' to 'Enabled: Default'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC"
$RegKey = "RpcAuthentication"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 0 (Enabled: Default)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 0 -Type DWord
Write-Output "'Configure RPC connection settings: Use authentication for outgoing RPC connections' is now set to 'Enabled: Default'."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0) {
    Write-Output "Verification successful: 'Configure RPC connection settings' is set to 'Enabled: Default'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 0."
}
