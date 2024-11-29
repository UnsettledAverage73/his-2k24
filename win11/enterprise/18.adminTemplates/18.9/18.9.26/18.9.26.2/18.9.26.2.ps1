# check.ps1
# Script to check if 'Configures LSASS to run as a protected process' is set to 'Enabled with UEFI Lock'

# Registry path and key
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$RegKey = "RunAsPPL"

# Check if the registry key exists and the value is set to 1 (Enabled)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Pass: 'Configures LSASS to run as a protected process' is set to 'Enabled with UEFI Lock'."
} else {
    Write-Output "Fail: 'Configures LSASS to run as a protected process' is not set correctly. Current value: $CurrentValue (Expected: 1)."
}
