# remedi.ps1
# Script to set 'Allow Custom SSPs and APs to be loaded into LSASS' to 'Disabled'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$RegKey = "AllowCustomSSPsAPs"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 0 (Disabled)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 0 -Type DWord
Write-Output "'Allow Custom SSPs and APs to be loaded into LSASS' is now set to 'Disabled'."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 0) {
    Write-Output "Verification successful: 'Allow Custom SSPs and APs to be loaded into LSASS' is set to 'Disabled'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 0."
}
