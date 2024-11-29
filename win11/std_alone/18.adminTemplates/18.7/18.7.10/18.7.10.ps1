# check.ps1
# Script to check if 'Point and Print Restrictions: When installing drivers for a new connection' is set to 'Enabled: Show warning and elevation prompt'

# Registry path and key
$RegPath = "HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
$RegKey = "NoWarningNoElevationOnInstall"

# Check if the registry key exists and the value is set to 0
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0) {
    Write-Output "Pass: 'Point and Print Restrictions: When installing drivers for a new connection' is set to 'Enabled: Show warning and elevation prompt'."
} else {
    Write-Output "Fail: 'Point and Print Restrictions: When installing drivers for a new connection' is not set correctly. Current value: $CurrentValue (Expected: 0)."
}
