# check.ps1
# Script to check if 'Prohibit connection to non-domain networks when connected to domain authenticated network' is set to 'Enabled'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy"
$RegKey = "fBlockNonDomain"

# Check if the registry key exists and the value is set to 1 (Enabled)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Pass: 'Prohibit connection to non-domain networks when connected to domain authenticated network' is set to 'Enabled'."
} else {
    Write-Output "Fail: 'Prohibit connection to non-domain networks when connected to domain authenticated network' is not set correctly. Current value: $CurrentValue"
}
