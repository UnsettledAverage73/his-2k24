# check.ps1
# Script to check if 'Manage processing of Queue-specific files' is set to 'Enabled: Limit Queue-specific files to Color profiles'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$RegKey = "CopyFilesPolicy"

# Check if the registry key exists and the value is set to 1
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Pass: 'Manage processing of Queue-specific files' is set to 'Enabled: Limit Queue-specific files to Color profiles'."
} else {
    Write-Output "Fail: 'Manage processing of Queue-specific files' is not set correctly. Current value: $CurrentValue (Expected: 1)."
}
