# check.ps1
# Script to check if 'Do not display network selection UI' is set to 'Enabled'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$RegKey = "DontDisplayNetworkSelectionUI"

# Check if the registry key exists and the value is set to 1 (Enabled)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Pass: 'Do not display network selection UI' is set to 'Enabled'."
} else {
    Write-Output "Fail: 'Do not display network selection UI' is not set correctly. Current value: $CurrentValue (Expected: 1)."
}
