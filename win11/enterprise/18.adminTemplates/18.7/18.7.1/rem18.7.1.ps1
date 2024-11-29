# remedi.ps1
# Script to set 'Allow Print Spooler to accept client connections' to 'Disabled'

# Registry path and key
$RegPath = "HKLM:\Software\Policies\Microsoft\Windows NT\Printers"
$RegKey = "RegisterSpoolerRemoteRpcEndPoint"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 2 (Disabled)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 2 -Type DWord
Write-Output "'Allow Print Spooler to accept client connections' is now set to 'Disabled'."

# Restart the Print Spooler service for the changes to take effect
Write-Output "Restarting the Print Spooler service..."
Restart-Service -Name "Spooler" -Force

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 2) {
    Write-Output "Verification successful: 'Allow Print Spooler to accept client connections' is set to 'Disabled'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 2."
}
