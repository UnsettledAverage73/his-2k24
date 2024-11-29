# remedi.ps1
# Script to set 'Minimize the number of simultaneous connections to the Internet or a Windows Domain' to 'Enabled: 3 = Prevent Wi-Fi when on Ethernet'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy"
$RegKey = "fMinimizeConnections"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 3 (Enabled: Prevent Wi-Fi when on Ethernet)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 3 -Type DWord
Write-Output "'Minimize the number of simultaneous connections' is now set to 'Enabled: 3 = Prevent Wi-Fi when on Ethernet'."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 3) {
    Write-Output "Verification successful: 'Minimize the number of simultaneous connections' is set to 'Enabled: 3'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 3."
}
