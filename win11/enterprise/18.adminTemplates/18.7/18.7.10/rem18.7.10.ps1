# remedi.ps1
# Script to set 'Point and Print Restrictions: When installing drivers for a new connection' to 'Enabled: Show warning and elevation prompt'

# Registry path and key
$RegPath = "HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
$RegKey = "NoWarningNoElevationOnInstall"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 0
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 0 -Type DWord
Write-Output "'Point and Print Restrictions: When installing drivers for a new connection' is now set to 'Enabled: Show warning and elevation prompt'."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0) {
    Write-Output "Verification successful: 'Point and Print Restrictions: When installing drivers for a new connection' is set to 'Enabled: Show warning and elevation prompt'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 0."
}
