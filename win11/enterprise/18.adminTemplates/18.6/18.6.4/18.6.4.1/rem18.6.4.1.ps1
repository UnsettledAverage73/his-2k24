# remedi.ps1
# Script to set DoHPolicy to Allow DoH (2)

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
$RegKey = "DoHPolicy"

# Ensure the registry key exists and set its value to Allow DoH (2)
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to Allow DoH (2)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 2 -Type DWord

# Verify the change
$value = Get-ItemProperty -Path $RegPath -Name $RegKey | Select-Object -ExpandProperty $RegKey
if ($value -eq 2) {
    Write-Output "Remediation successful: DoHPolicy is now set to Allow DoH (2)."
} else {
    Write-Output "Remediation failed: Unable to set DoHPolicy to Allow DoH (2)."
}
