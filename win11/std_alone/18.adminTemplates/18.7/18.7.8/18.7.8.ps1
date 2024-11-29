# check.ps1
# Script to check if 'Limits print driver installation to Administrators' is set to 'Enabled'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
$RegKey = "RestrictDriverInstallationToAdministrators"

# Check if the registry key exists and the value is set to 1
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Pass: 'Limits print driver installation to Administrators' is set to 'Enabled'."
} else {
    Write-Output "Fail: 'Limits print driver installation to Administrators' is not set correctly. Current value: $CurrentValue (Expected: 1)."
}
