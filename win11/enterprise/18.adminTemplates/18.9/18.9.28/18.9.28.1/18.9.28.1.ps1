# check.ps1
# Script to check if 'Block user from showing account details on sign-in' is set to 'Enabled'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$RegKey = "BlockUserFromShowingAccountDetailsOnSignin"

# Check if the registry key exists and the value is set to 1 (Enabled)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Pass: 'Block user from showing account details on sign-in' is set to 'Enabled'."
} else {
    Write-Output "Fail: 'Block user from showing account details on sign-in' is not set correctly. Current value: $CurrentValue (Expected: 1)."
}
