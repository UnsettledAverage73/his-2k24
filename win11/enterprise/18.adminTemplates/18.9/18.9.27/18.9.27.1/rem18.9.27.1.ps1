# remedi.ps1
# Script to set 'Disallow copying of user input methods to the system account for sign-in' to 'Enabled'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Control Panel\International"
$RegKey = "BlockUserInputMethodsForSignIn"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 1 (Enabled)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 1 -Type DWord
Write-Output "'Disallow copying of user input methods to the system account for sign-in' is now set to 'Enabled'."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Verification successful: 'Disallow copying of user input methods to the system account for sign-in' is set to 'Enabled'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 1."
}
