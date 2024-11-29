# remedi.ps1
# Script to disable IPv6 by setting DisabledComponents to 0xff (255)

# Registry path and key
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters"
$RegKey = "DisabledComponents"
$ValueToSet = 255

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the DisabledComponents value
Set-ItemProperty -Path $RegPath -Name $RegKey -Value $ValueToSet -Type DWord

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey
if ($CurrentValue -eq $ValueToSet) {
    Write-Output "Remediation successful: IPv6 is disabled (DisabledComponents set to $ValueToSet)."
} else {
    Write-Output "Remediation failed. Current value: $CurrentValue. Expected value: $ValueToSet."
}
