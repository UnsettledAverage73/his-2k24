# remedi.ps1
# Script to disable multicast name resolution (turn off LLMNR)

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
$RegKey = "EnableMulticast"

# Ensure the registry key exists and set its value to 0 (disable multicast name resolution)
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 0 (turn off multicast name resolution)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 0 -Type DWord

# Verify the change
$value = Get-ItemProperty -Path $RegPath -Name $RegKey | Select-Object -ExpandProperty $RegKey
if ($value -eq 0) {
    Write-Output "Remediation successful: Multicast name resolution is turned off (LLMNR is disabled)."
} else {
    Write-Output "Remediation failed: Unable to turn off multicast name resolution (LLMNR)."
}
