# remedi.ps1
# Script to disable insecure guest logons

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation"
$RegKey = "AllowInsecureGuestAuth"

# Ensure the registry path exists and set its value to 0 (disable insecure guest logons)
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 0 (disable insecure guest logons)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 0 -Type DWord

# Verify the change
$value = Get-ItemProperty -Path $RegPath -Name $RegKey | Select-Object -ExpandProperty $RegKey
if ($value -eq 0) {
    Write-Output "Remediation successful: Insecure guest logons are disabled."
} else {
    Write-Output "Remediation failed: Unable to disable insecure guest logons."
}
