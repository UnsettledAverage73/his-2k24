# check.ps1
# Script to check if 'Prohibit access of the Windows Connect Now wizards' is enabled

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WCN\UI"
$RegKey = "DisableWcnUi"

# Check if the registry key exists and the value is set to 1 (enabled)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Pass: 'Prohibit access of the Windows Connect Now wizards' is enabled."
} else {
    Write-Output "Fail: 'Prohibit access of the Windows Connect Now wizards' is not enabled. Current value: $CurrentValue"
}
