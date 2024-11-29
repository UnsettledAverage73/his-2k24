# check.ps1
# Script to check if 'Disallow copying of user input methods to the system account for sign-in' is set to 'Enabled'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Control Panel\International"
$RegKey = "BlockUserInputMethodsForSignIn"

# Check if the registry key exists and the value is set to 1 (Enabled)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Pass: 'Disallow copying of user input methods to the system account for sign-in' is set to 'Enabled'."
} else {
    Write-Output "Fail: 'Disallow copying of user input methods to the system account for sign-in' is not set correctly. Current value: $CurrentValue (Expected: 1)."
}
