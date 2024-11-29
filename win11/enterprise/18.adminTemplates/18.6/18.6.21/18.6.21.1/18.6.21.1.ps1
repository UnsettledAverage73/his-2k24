# check.ps1
# Script to check if 'Minimize the number of simultaneous connections to the Internet or a Windows Domain' is set to 'Enabled: 3'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy"
$RegKey = "fMinimizeConnections"

# Check if the registry key exists and the value is set to 3 (Prevent Wi-Fi when on Ethernet)
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 3) {
    Write-Output "Pass: 'Minimize the number of simultaneous connections' is set to 'Enabled: 3 = Prevent Wi-Fi when on Ethernet'."
} else {
    Write-Output "Fail: 'Minimize the number of simultaneous connections' is not set correctly. Current value: $CurrentValue"
}
