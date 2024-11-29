# check.ps1
# Script to check if 'Configure Redirection Guard' is set to 'Enabled: Redirection Guard Enabled'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$RegKey = "RedirectionguardPolicy"

# Check if the registry key exists and the value is set to 1 (Enabled)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Pass: 'Configure Redirection Guard' is set to 'Enabled: Redirection Guard Enabled'."
} else {
    Write-Output "Fail: 'Configure Redirection Guard' is not set correctly. Current value: $CurrentValue"
}
