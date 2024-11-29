# remedi.ps1
# Script to disable NetBIOS name resolution on public networks (set EnableNetbios to 0)

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
$RegKey = "EnableNetbios"

# Ensure the registry key exists and set its value to 0 (Disable NetBIOS on public networks)
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 0 (Disable NetBIOS on public networks)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 0 -Type DWord

# Verify the change
$value = Get-ItemProperty -Path $RegPath -Name $RegKey | Select-Object -ExpandProperty $RegKey
if ($value -eq 0) {
    Write-Output "Remediation successful: NetBIOS name resolution is disabled on public networks."
} else {
    Write-Output "Remediation failed: Unable to disable NetBIOS name resolution on public networks."
}
