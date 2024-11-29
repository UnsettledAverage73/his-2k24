# remedi.ps1
# Script to set 'Manage processing of Queue-specific files' to 'Enabled: Limit Queue-specific files to Color profiles'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$RegKey = "CopyFilesPolicy"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 1
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 1 -Type DWord
Write-Output "'Manage processing of Queue-specific files' is now set to 'Enabled: Limit Queue-specific files to Color profiles'."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Verification successful: 'Manage processing of Queue-specific files' is set to 'Enabled: Limit Queue-specific files to Color profiles'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 1."
}
