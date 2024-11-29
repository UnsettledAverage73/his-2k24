# check.ps1
# Script to check if 'Allow Custom SSPs and APs to be loaded into LSASS' is set to 'Disabled'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$RegKey = "AllowCustomSSPsAPs"

# Check if the registry key exists and the value is set to 0 (Disabled)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0) {
    Write-Output "Pass: 'Allow Custom SSPs and APs to be loaded into LSASS' is set to 'Disabled'."
} else {
    Write-Output "Fail: 'Allow Custom SSPs and APs to be loaded into LSASS' is not set correctly. Current value: $CurrentValue (Expected: 0)."
}
